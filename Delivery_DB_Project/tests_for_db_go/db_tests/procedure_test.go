package DbTests

import (
	"context"
	"log"
	"testing"

	"github.com/jackc/pgx/v5"
)

func TestProcedures(t *testing.T) {
	dbURL := "postgres://postgres:_________@localhost:5432/hw_mipt_db_2025"
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	ProcedureCalls := []procedureTests{
		{"CALL_5061-5062", "CALL dp.add_orders(ARRAY[ ROW(5061, 'Пирожок', 10, 2, DATE '2024-04-25', 5, 3)::dp.order_type, ROW(5062, 'Пирожок', 11, 1, DATE '2024-04-25', 5, 4)::dp.order_type]);"},
		{"CALL_5063-5064", "CALL dp.add_orders(ARRAY[ ROW(5063, 'Сэндвич', 10, 2, DATE '2024-04-25', 5, 3)::dp.order_type, ROW(5064, 'Пирожок', 11, 1, DATE '2024-04-25', 5, 4)::dp.order_type]);"},
		{"delete_from_dp.h_orders", "DELETE FROM dp.h_orders WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"delete_from_dp.active_couriers", "DELETE FROM dp.active_couriers WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"delete_from_dp.orders_in_cafe", "DELETE FROM dp.orders_in_cafe WHERE Order_id BETWEEN 5061 AND 5064;"},
		{"delete_from_dp.a_orders", "DELETE FROM dp.a_orders WHERE Order_id BETWEEN 5061 AND 5064;"}}

	for _, tt := range ProcedureCalls {
		t.Run(tt.TestName, func(t *testing.T) {
			_, err := conn.Exec(ctx, tt.CallCommand)
			if err != nil {
				t.Fatalf("Ошибка при выполнении запроса: %v", err)
			}
		})
	}
}
