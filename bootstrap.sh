#!/bin/bash

# Create a new Organisation
ORG_ID=$(curl --silent \
  --header "admin-auth: 12345" \
  --header "Content-Type:application/json" \
  --data '{ "owner_name": "Demo User", "cname_enabled": true, "cname": "example", "hybrid_enabled": true, "event_options": { "key_event": { "email": "test@test.com" }, "hashed_key_event": { "email": "test@test.com" } } }' \
  localhost:3000/admin/organisations | jq -r '.Meta')

# Create a new ADMIN User
USER=$(curl --silent \
  --header "admin-auth: 12345" \
  --header "Content-Type:application/json" \
  --data '{ "first_name": "admin", "last_name": "user", "email_address": "admin@gmail.com", "active": true, "org_id": "'$ORG_ID'", "user_permissions": { "IsAdmin": "admin" } }' \
  localhost:3000/admin/users)

USER_ID=$(echo $USER | jq -r '.Meta.id')
USER_KEY=$(echo $USER | jq -r '.Meta.access_key')

# Set a password for ADMIN User
USER=$(curl --silent \
  --header "authorization: $USER_KEY" \
  --header "Content-Type:application/json" \
  --data '{ "new_password": "password", "user_permissions": { "IsAdmin": "admin" } }' \
  localhost:3000/api/users/$USER_ID/actions/reset  | jq -r '.Meta')