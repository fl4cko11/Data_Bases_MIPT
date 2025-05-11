package DbTests

import (
	"context"
	"log"
	"os"
	"path/filepath"
	"testing"
	"tests_for_db_go/ORM"

	"github.com/jackc/pgx/v5"
)

func TestAllQueriesAsserts(t *testing.T) {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	// Описываем тесты: имя SQL файла и ожидаемый результат (значение и колонка)
	tests := []queryTests{
		{"01_popular_client.sql", 10, 0},                    // тест 1, клиент с id 10
		{"02_unpopular_client.sql", 23, 0},                  // тест 2, клиент с id 23
		{"03_popular_cafe.sql", 16, 0},                      // тест 3, клиент с id 16
		{"04_unpopular_cafe.sql", 20, 0},                    // тест 4, кафе с id 20
		{"05_active_courier.sql", 20, 0},                    // тест 5, кафе с id 20
		{"07_most_popular_item_now.sql", "Капучино", 0},     // тест 7, позиция Капучино
		{"08_most_unpopular_item_now.sql", "Смузи боул", 0}, // тест 8, позиция Смузи боул
		{"10_most_tired_courier_now.sql", 1, 0},             // тест 10, курьер с id 1
		{"11_most_relaxed_courier.sql", 11, 0},              // тест 11, курьер с id 11
	}

	basePath := "../../scripts/queries"

	for _, tc := range tests {
		t.Run(tc.fileName, func(t *testing.T) {
			// Читаем SQL из файла
			fullFileName := filepath.Join(basePath, tc.fileName)
			sqlBytes, err := os.ReadFile(fullFileName)
			if err != nil {
				t.Fatalf("Не удалось прочитать файл %s: %v", tc.fileName, err)
			}
			sqlText := string(sqlBytes)

			// Выполняем запрос (ожидаем ровно одну строку с нужным результатом)
			row := conn.QueryRow(ctx, sqlText)

			// Сканируем результат - предполагаем один столбец/одно значение, но
			// если надо, можно завести []interface{} с нужной длиной.

			var val any
			//используем Scan в зависимости от типа ожидаемого значения
			switch v := tc.expectedValue.(type) {
			case int:
				var tmp int
				err = row.Scan(&tmp)
				val = tmp
			case string:
				var tmp string
				err = row.Scan(&tmp)
				val = tmp
			default:
				t.Fatalf("Unsupported expected value type %T", v)
			}
			if err != nil {
				t.Fatalf("Ошибка при выполнении запроса или чтении результата: %v", err)
			}

			// Сравниваем с ожидаемым значением
			if val != tc.expectedValue {
				t.Errorf("Неверный результат для %s: ожидалось %v, получили %v", tc.fileName, tc.expectedValue, val)
			}
		})
	}
}

func TestGetPopularClientQuery(t *testing.T) {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	OrmResult := ORM.GetMostPopularClient(dbURL, "dp.h_orders")

	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	row := conn.QueryRow(ctx, "SELECT client_id FROM (SELECT client_id, COUNT(dp.h_orders.client_id) AS count FROM dp.h_orders GROUP BY dp.h_orders.client_id ORDER BY count DESC LIMIT 1);")

	var SqlResult int
	err = row.Scan(&SqlResult)
	if err != nil {
		t.Fatalf("Ошибка при выполнении запроса или чтении результата: %v", err)
	}

	if OrmResult != SqlResult {
		t.Errorf("Неверный результат: ожидалось %v, получили %v", OrmResult, SqlResult)
	}
}

func TestGetUnpopularClientQuery(t *testing.T) {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	OrmResult := ORM.GetMostUnpopularClient(dbURL, "dp.h_orders")

	ctx := context.Background()

	conn, err := pgx.Connect(ctx, dbURL)
	if err != nil {
		log.Fatalf("Не удалось подключиться к базе данных: %v", err)
	}
	defer conn.Close(ctx)

	row := conn.QueryRow(ctx, "SELECT client_id FROM (SELECT client_id, COUNT(dp.h_orders.client_id) AS count FROM dp.h_orders GROUP BY dp.h_orders.client_id ORDER BY count ASC LIMIT 1);")

	var SqlResult int
	err = row.Scan(&SqlResult)
	if err != nil {
		t.Fatalf("Ошибка при выполнении запроса или чтении результата: %v", err)
	}

	if OrmResult != SqlResult {
		t.Errorf("Неверный результат: ожидалось %v, получили %v", OrmResult, SqlResult)
	}
}
