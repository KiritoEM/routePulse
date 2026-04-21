import { SQL } from "drizzle-orm";
import { PgColumn, PgSelect } from "drizzle-orm/pg-core";

export function withPagination<T extends PgSelect>(
  qb: T,
  page = 1,
  pageSize = 20
) : T {
  return qb
    .limit(pageSize)
    .offset((page - 1) * pageSize);
}
