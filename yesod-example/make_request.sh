#!/usr/bin/env bash

set -euo pipefail

curl -X POST http://localhost:3000/fancy -H "Content-Type: application/json" -d @example_post_body.json
