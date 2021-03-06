/* puavo-conf
 * Copyright (C) 2016 Opinsys Oy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef PUAVO_CONF_DB_H
#define PUAVO_CONF_DB_H

#include "common.h"

int puavo_conf_db_add(struct puavo_conf *conf,
                      char const *key,
                      char const *value,
                      struct puavo_conf_err *errp);

int puavo_conf_db_clear(struct puavo_conf *conf, struct puavo_conf_err *errp);

int puavo_conf_db_close(struct puavo_conf *conf, struct puavo_conf_err *errp);

int puavo_conf_db_get(struct puavo_conf *conf,
                      char const *key,
                      char **valuep,
                      struct puavo_conf_err *errp);

int puavo_conf_db_get_all(struct puavo_conf *conf,
                          struct puavo_conf_list *list,
                          struct puavo_conf_err *errp);

int puavo_conf_db_has_key(struct puavo_conf *conf,
                          char const *key,
                          bool *haskey,
                          struct puavo_conf_err *errp);

int puavo_conf_db_open(struct puavo_conf *conf, struct puavo_conf_err *errp);

int puavo_conf_db_overwrite(struct puavo_conf *conf,
                            char const *key,
                            char const *value,
                            struct puavo_conf_err *errp);

int puavo_conf_db_set(struct puavo_conf *conf,
                      char const *key,
                      char const *value,
                      struct puavo_conf_err *errp);

static const struct puavo_conf_ops PUAVO_CONF_OPS_DB = {
        .add       = puavo_conf_db_add,
        .clear     = puavo_conf_db_clear,
        .close     = puavo_conf_db_close,
        .get       = puavo_conf_db_get,
        .get_all   = puavo_conf_db_get_all,
        .has_key   = puavo_conf_db_has_key,
        .open      = puavo_conf_db_open,
        .overwrite = puavo_conf_db_overwrite,
        .set       = puavo_conf_db_set,
};

#endif /* PUAVO_CONF_DB_H */
