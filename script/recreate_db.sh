#! /bin/bash
sequel -M 0 -m migrations -E postgres://stld:stld@localhost:5432/stld_$1 &&
sequel -m migrations -E postgres://stld:stld@localhost:5432/stld_$1
