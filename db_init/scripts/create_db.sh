#!/bin/bash

DB_NAME="project_4sem"
DB_USER="postgres"

psql -U $DB_USER -d $DB_NAME -f ../schema/01_create_schema.sql
psql -U $DB_USER -d $DB_NAME -f ../schema/02_create_tables.sql
