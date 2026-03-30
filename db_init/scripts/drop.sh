#!/bin/bash

DB_NAME="project_4sem"
DB_USER="postgres"

psql -U $DB_USER -d $DB_NAME -f ../schema/00_drop_all.sql
