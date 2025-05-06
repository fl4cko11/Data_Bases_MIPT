package ORM

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5"
)

func ScanDBTable(dbURL string, table_name string) []HOrdersRow {
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	rows, err := conn.Query(ctx, "SELECT * FROM "+table_name+";")
	if err != nil {
		log.Fatalf("Не удалось считать строки: %v", err)
	}
	defer rows.Close()

	var orders []HOrdersRow

	for rows.Next() {
		var o HOrdersRow
		err := rows.Scan(
			&o.OrderId,
			&o.OrderItem,
			&o.ClientId,
			&o.Quantity,
			&o.Date,
			&o.CafeId,
			&o.CourierId,
		)
		if err != nil {
			log.Fatalf("Scan failed: %v\n", err)
		}
		orders = append(orders, o)
	}
	return orders
}

func GetMostPopularClient(dbURL string, table_name string) int {
	orders := ScanDBTable(dbURL, table_name)

	countMap := make(map[int]int, 1000)

	for _, value := range orders {
		countMap[value.ClientId] = countMap[value.ClientId] + 1
	}

	var maxClientId int
	maxCount := 0
	for clientId, count := range countMap {
		if count > maxCount {
			maxCount = count
			maxClientId = clientId
		}
	}

	return maxClientId
}

func GetMostUnpopularClient(dbURL string, table_name string) int {
	orders := ScanDBTable(dbURL, table_name)

	countMap := make(map[int]int, 1000)

	for _, value := range orders {
		countMap[value.ClientId] = countMap[value.ClientId] + 1
	}

	var minClientId int
	for key := range countMap {
		minClientId = key
	}

	minCount := countMap[minClientId]
	for clientId, count := range countMap {
		if count < minCount {
			minCount = count
			minClientId = clientId
		}
	}

	return minClientId
}
