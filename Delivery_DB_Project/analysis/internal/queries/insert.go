package queries

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/jackc/pgx/v5"
)

func randomDate() string {
	now := time.Now()
	randomDaysAgo := rand.Intn(30)
	randomDate := now.AddDate(0, 0, -randomDaysAgo)
	return randomDate.Format("2006-01-02")
}

func generateRandomOrders(n int) []HOrdersRow {
	orderItems := []string{
		"Капучино",
		"Эспрессо",
		"Латте",
		"Макиато",
		"Американо",
		"Чай чёрный",
		"Чай зелёный",
		"Сок апельсиновый",
		"Пирожное",
		"Сэндвич",
	}

	result := make([]HOrdersRow, n)

	for i := 0; i < n; i++ {
		result[i] = HOrdersRow{
			OrderId:   rand.Intn(50) + 6001,
			OrderItem: orderItems[rand.Intn(len(orderItems))],
			ClientId:  rand.Intn(30) + 1,
			Quantity:  rand.Intn(25) + 1,
			Date:      randomDate(),
			CafeId:    rand.Intn(30) + 1,
			CourierId: rand.Intn(30) + 1,
		}
	}

	return result
}

func InsertOrder(OrderId int, OrderItem string, ClientId int, Quantity int, Date string, CafeId int, CourierId int) {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	_, err_ := conn.Exec(ctx, `CALL dp.add_orders(ARRAY[ROW($1, $2, $3, $4, $5::date, $6, $7)::dp.order_type]);`, OrderId, OrderItem, ClientId, Quantity, Date, CafeId, CourierId)
	if err_ != nil {
		fmt.Printf("Ошибка при выполнении запроса: %v", err_)
	}
}

func InsertRandomOrders(Number int) {
	Orders := generateRandomOrders(Number)
	for _, o := range Orders {
		InsertOrder(o.OrderId, o.OrderItem, o.ClientId, o.Quantity, o.Date, o.CafeId, o.CourierId)
	}
}
