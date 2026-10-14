#!/usr/bin/env bash
set -e

BASE="${1:-https://gateway-workshop-demo.apps.ocp.ks75b.sandbox3353.opentlc.com}"

post() { curl -sk -X POST "$BASE$1" -H "Content-Type: application/json" -d "$2"; }
id_of() { python3 -c "import sys,json; print(json.load(sys.stdin)['id'])"; }

echo "Seeding users..."
U1=$(post /users '{"name":"Alice Martin","email":"alice@example.com"}' | id_of)
U2=$(post /users '{"name":"Bob Singh","email":"bob@example.com"}' | id_of)
U3=$(post /users '{"name":"Carmen Lopez","email":"carmen@example.com"}' | id_of)
U4=$(post /users '{"name":"David Chen","email":"david@example.com"}' | id_of)
U5=$(post /users '{"name":"Eva Rossi","email":"eva@example.com"}' | id_of)

echo "Seeding products..."
P1=$(post /products '{"name":"Mechanical Keyboard","description":"Tactile switches, RGB backlit","price":129.99}' | id_of)
P2=$(post /products '{"name":"USB-C Hub","description":"7-in-1 multiport adapter","price":49.99}' | id_of)
P3=$(post /products '{"name":"Webcam 4K","description":"Auto-focus, built-in mic","price":89.99}' | id_of)
P4=$(post /products '{"name":"Standing Desk Mat","description":"Anti-fatigue, 32x20 inch","price":34.99}' | id_of)
P5=$(post /products '{"name":"Monitor Light Bar","description":"Clip-on, no glare screen light","price":39.99}' | id_of)

echo "Seeding inventory..."
post /inventory "{\"product_id\":\"$P1\",\"quantity\":50,\"location\":\"Warehouse A\"}" > /dev/null
post /inventory "{\"product_id\":\"$P2\",\"quantity\":120,\"location\":\"Warehouse A\"}" > /dev/null
post /inventory "{\"product_id\":\"$P3\",\"quantity\":30,\"location\":\"Warehouse B\"}" > /dev/null
post /inventory "{\"product_id\":\"$P4\",\"quantity\":75,\"location\":\"Warehouse B\"}" > /dev/null
post /inventory "{\"product_id\":\"$P5\",\"quantity\":60,\"location\":\"Warehouse C\"}" > /dev/null

echo "Seeding orders..."
post /orders "{\"user_id\":\"$U1\",\"product_id\":\"$P1\",\"quantity\":1}" > /dev/null
post /orders "{\"user_id\":\"$U2\",\"product_id\":\"$P3\",\"quantity\":2}" > /dev/null
post /orders "{\"user_id\":\"$U3\",\"product_id\":\"$P2\",\"quantity\":1}" > /dev/null
post /orders "{\"user_id\":\"$U4\",\"product_id\":\"$P5\",\"quantity\":3}" > /dev/null
post /orders "{\"user_id\":\"$U5\",\"product_id\":\"$P4\",\"quantity\":2}" > /dev/null

echo ""
echo "Done. Records created:"
echo "  Users:     $(curl -sk $BASE/users     | python3 -c "import sys,json; print(len(json.load(sys.stdin)))")"
echo "  Products:  $(curl -sk $BASE/products  | python3 -c "import sys,json; print(len(json.load(sys.stdin)))")"
echo "  Inventory: $(curl -sk $BASE/inventory | python3 -c "import sys,json; print(len(json.load(sys.stdin)))")"
echo "  Orders:    $(curl -sk $BASE/orders    | python3 -c "import sys,json; print(len(json.load(sys.stdin)))")"
