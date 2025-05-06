package analysis_funcs

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5"
)

func ScanDBQuantityItem(dbURL string) []QuantityItem {
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	rows, err := conn.Query(ctx, "SELECT SUM(quantity) AS sum_quantity, order_item FROM dp.h_orders WHERE order_item != 'Капучино' GROUP BY order_item;")
	if err != nil {
		log.Fatalf("Не удалось считать строки: %v", err)
	}
	defer rows.Close()

	var data []QuantityItem

	for rows.Next() {
		var qi QuantityItem
		err := rows.Scan(&qi.Quantity, &qi.OrderItem)
		if err != nil {
			log.Fatalf("Проблема с сканированием: %v\n", err)
		}
		data = append(data, qi)
	}
	return data
}

func ScanDBCafeRating(dbURL string) []CafeRaiting {
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	rows, err := conn.Query(ctx, "SELECT COUNT(cafe_id), rating FROM dp.cafes GROUP BY rating;")
	if err != nil {
		log.Fatalf("Не удалось считать строки: %v", err)
	}
	defer rows.Close()

	var data []CafeRaiting

	for rows.Next() {
		var qi CafeRaiting
		err := rows.Scan(&qi.CafeCount, &qi.Rating)
		if err != nil {
			log.Fatalf("Проблема с сканированием: %v\n", err)
		}
		data = append(data, qi)
	}
	return data
}

func ScanDBCourierCafeRelation(dbURL string) []CourierCafe {
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	rows, err := conn.Query(ctx, "SELECT courier_id, cafe_id FROM dp.active_couriers;")
	if err != nil {
		log.Fatalf("Не удалось считать строки: %v", err)
	}
	defer rows.Close()

	var data []CourierCafe

	for rows.Next() {
		var qi CourierCafe
		err := rows.Scan(&qi.CourierId, &qi.CafeId)
		if err != nil {
			log.Fatalf("Проблема с сканированием: %v\n", err)
		}
		data = append(data, qi)
	}
	return data
}
