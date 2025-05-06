package analysis_funcs

import (
	"context"
	"log"
	"math/rand"
	"os"
	"os/exec"

	"github.com/go-echarts/go-echarts/v2/charts"
	"github.com/go-echarts/go-echarts/v2/opts"
	"github.com/go-echarts/go-echarts/v2/types"
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

// generateRandomColors генерирует список случайных цветов в HEX формате
func generateRandomColors(n int) []string {
	colors := make([]string, n)
	for i := 0; i < n; i++ {
		colors[i] = randomHexColor()
	}
	return colors
}

// randomHexColor генерирует случайный цвет в HEX формате
func randomHexColor() string {
	letters := []byte("0123456789ABCDEF")
	color := make([]byte, 6)
	for i := range color {
		color[i] = letters[rand.Intn(len(letters))]
	}
	return "#" + string(color)
}

func Graph() {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	data := ScanDBQuantityItem(dbURL)

	// Создаём новую гистограмму
	bar := charts.NewBar()
	bar.SetGlobalOptions(
		charts.WithInitializationOpts(opts.Initialization{
			Theme:  types.ThemeWesteros, // Можно выбрать другую тему
			Width:  "1200px",
			Height: "600px",
		}),
		charts.WithTitleOpts(opts.Title{
			Title:    "Количество заказов по предметам",
			Subtitle: "Гистограмма количества заказов",
		}),
		charts.WithXAxisOpts(opts.XAxis{
			Name: "Предмет заказа",
			AxisLabel: &opts.AxisLabel{
				Show:     opts.Bool(true),
				Rotate:   45,  // Наклон подписей для удобочитаемости (поставьте 0, если не нужен)
				Interval: "0", // Показывать подпись для каждого значения, без пропусков
				// Можно добавить выравнивание, цвет, размер и др. настройки
			},
		}),
		charts.WithYAxisOpts(opts.YAxis{
			Name: "Количество заказов",
		}),
		charts.WithTooltipOpts(opts.Tooltip{
			Show:    opts.Bool(true),
			Trigger: "axis",
		}),
		charts.WithLegendOpts(opts.Legend{
			Show: opts.Bool(false), // за анимацию
		}),
		charts.WithGridOpts(opts.Grid{
			Top: "25%", // например, 25% или в пикселях "150px" — подберите удобное значение
		}),
	)

	// Подготавливаем данные для оси X (названия предметов)
	var xAxis []string
	// Подготавливаем данные для оси Y (количества)
	var seriesData []opts.BarData

	// Генерируем случайные цвета для каждого столбца
	colors := generateRandomColors(len(data))

	// Заполняем данные
	for _, item := range data {
		xAxis = append(xAxis, item.OrderItem)
		seriesData = append(seriesData, opts.BarData{
			Value: item.Quantity,
			ItemStyle: &opts.ItemStyle{
				Color: colors[len(xAxis)-1], // Присваиваем цвет из заранее сгенерированного списка
			},
		})
	}

	// Добавляем данные в гистограмму
	bar.SetXAxis(xAxis).AddSeries("Количество заказов", seriesData)

	// Создаём файл для вывода графика
	f, err := os.Create("bar_chart.html")
	if err != nil {
		log.Fatalf("Не удалось создать файл: %v", err)
	}
	defer f.Close()

	// Рендерим график в файл
	err = bar.Render(f)
	if err != nil {
		log.Fatalf("Не удалось отрендерить график: %v", err)
	}

	log.Println("Гистограмма успешно сохранена в bar_chart.html")

	cmd := exec.Command("google-chrome-stable", "/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/analysis/cmd/bar_chart.html")
	err_ := cmd.Run()
	if err_ != nil {
		log.Fatalf("Не удалось запустить браузер: %v", err)
	}
}
