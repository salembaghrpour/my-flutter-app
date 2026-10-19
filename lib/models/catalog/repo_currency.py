from decimal import Decimal
from typing import Any, Optional

from api.modules.catalog.repo_common import unwrap_conn


def _fetchone(conn, sql: str, params=None) -> Optional[dict]:
    conn = unwrap_conn(conn)
    cur = conn.cursor()
    try:
        cur.execute(sql, params or ())
        row = cur.fetchone()
        if row is None:
            return None
        cols = [d[0] for d in cur.description]
        return dict(zip(cols, row))
    finally:
        cur.close()


def _to_float(value) -> Optional[float]:
    if value is None or value == "":
        return None
    if isinstance(value, Decimal):
        return float(value)
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _to_iso(value) -> Optional[str]:
    if value is None:
        return None
    if hasattr(value, "isoformat"):
        return value.isoformat()
    return str(value)


def currency_to_dict(row: dict) -> dict[str, Any]:
    return {
        "id": int(row["id"]),
        "accounting_id": int(row["accounting_id"]) if row.get("accounting_id") is not None else None,
        "base_currency_name": str(row.get("base_currency_name") or ""),
        "base_currency_symbol": str(row.get("base_currency_symbol") or ""),
        "var_currency_name": row.get("var_currency_name"),
        "var_currency_symbol": row.get("var_currency_symbol"),
        "exchange_rate": _to_float(row.get("exchange_rate")),
        "is_active": bool(row.get("is_active", True)),
        "last_updated": _to_iso(row.get("last_updated")),
        "synced_at": _to_iso(row.get("synced_at")),
    }


def get_active_currency(conn) -> Optional[dict]:
    row = _fetchone(
        conn,
        """
        SELECT
            id,
            accounting_id,
            base_currency_name,
            base_currency_symbol,
            var_currency_name,
            var_currency_symbol,
            exchange_rate,
            is_active,
            last_updated,
            synced_at
        FROM currencies_config
        WHERE is_active = TRUE
        ORDER BY last_updated DESC NULLS LAST, id DESC
        LIMIT 1
        """,
    )
    if row:
        return row

    return _fetchone(
        conn,
        """
        SELECT
            id,
            accounting_id,
            base_currency_name,
            base_currency_symbol,
            var_currency_name,
            var_currency_symbol,
            exchange_rate,
            is_active,
            last_updated,
            synced_at
        FROM currencies_config
        ORDER BY last_updated DESC NULLS LAST, id DESC
        LIMIT 1
        """,
    )
