package DbTests

import (
	"context"
	"log"
	"testing"

	"github.com/jackc/pgx/v5"
)

func TestProcedures(t *testing.T) {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	ProcedureCalls := []procedureTests{
		{"[TRIGGER_BEFORE] LF_1", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 1;"},
		{"[TRIGGER_BEFORE] VALUE_1", "SELECT value FROM dp.clients WHERE client_id = 1;"},
		{"[PROCEDURE]", "CALL dp.add_orders(ARRAY[ ROW(5061, 'Пирожок', 1, 2, DATE '2024-04-25', 1, 3)::dp.order_type, ROW(5062, 'Пирожок', 11, 1, DATE '2024-04-25', 1, 4)::dp.order_type]);"},
		{"[TRIGGER_AFTER] LF_1", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 1;"},
		{"[TRIGGER_AFTER] VALUE_1", "SELECT value FROM dp.clients WHERE client_id = 1;"},
		{"[TRIGGER_BEFORE] LF_2", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 2;"},
		{"[TRIGGER_BEFORE] VALUE_2", "SELECT value FROM dp.clients WHERE client_id = 2;"},
		{"[PROCEDURE]", "CALL dp.add_orders(ARRAY[ ROW(5063, 'Сэндвич', 2, 2, DATE '2024-04-25', 2, 3)::dp.order_type, ROW(5064, 'Пирожок', 11, 2, DATE '2024-04-25', 2, 4)::dp.order_type]);"},
		{"[TRIGGER_AFTER] LF_2", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 2;"},
		{"[TRIGGER_AFTER] VALUE_2", "SELECT value FROM dp.clients WHERE client_id = 2;"},
		{"[CLEAN_dp.h_orders]", "DELETE FROM dp.h_orders WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"[CLEAN_dp.active_couriers]", "DELETE FROM dp.active_couriers WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"[CLEAN_dp.orders_in_cafe]", "DELETE FROM dp.orders_in_cafe WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"[CLEAN_dp.a_orders]", "DELETE FROM dp.a_orders WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"[TRIGGER] LF_1", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 1;"},
		{"[TRIGGER] VALUE_1", "SELECT value FROM dp.clients WHERE client_id = 1;"},
		{"[TRIGGER] LF_2", "SELECT loaded_factor FROM dp.cafes WHERE cafe_id = 2;"},
		{"[TRIGGER] VALUE_2", "SELECT value FROM dp.clients WHERE client_id = 2;"}}

	for _, tt := range ProcedureCalls {
		t.Run(tt.testName, func(t *testing.T) {
			if startsWithSelect(tt.callCommand) {
				// Выполняем SELECT и печатаем результат
				row := conn.QueryRow(ctx, tt.callCommand)
				var result any
				err := row.Scan(&result)
				if err != nil {
					t.Fatalf("Ошибка при сканировании результата: %v", err)
				}
				log.Printf("\n%s: %v\n", tt.testName, result)
			} else {
				_, err := conn.Exec(ctx, tt.callCommand)
				if err != nil {
					t.Fatalf("Ошибка при выполнении запроса: %v", err)
				}
			}
		})
	}
}
