package analysis_funcs

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/exec"

	"github.com/go-echarts/go-echarts/v2/charts"
	"github.com/go-echarts/go-echarts/v2/opts"
	"github.com/go-echarts/go-echarts/v2/types"
)

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

func BarChartQuantityItem() {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	data := ScanDBQuantityItem(dbURL)

	// Создаём новую гистограмму
	bar := charts.NewBar()
	bar.SetGlobalOptions(
		charts.WithInitializationOpts(opts.Initialization{
			Theme:  types.ThemeWesteros, // Можно выбрать другую тему
			Width:  "1500px",
			Height: "900px",
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

func PieChartCafeRating() {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	data := ScanDBCafeRating(dbURL)

	// Генерация цветов
	colors := generateRandomColors(len(data))

	// Подготовка данных для диаграммы
	pieData := make([]opts.PieData, 0, len(data))
	for i, item := range data {
		pieData = append(pieData, opts.PieData{
			Name:  fmt.Sprintf("Кафе с рейтингом %d", item.Rating),
			Value: item.Rating,
			ItemStyle: &opts.ItemStyle{
				Color: colors[i],
			},
		})
	}

	pie := charts.NewPie()
	pie.SetGlobalOptions(
		charts.WithInitializationOpts(opts.Initialization{
			Theme:  types.ThemeWesteros,
			Width:  "1200px",
			Height: "900px",
		}),
		charts.WithTitleOpts(opts.Title{
			Title:    "Рейтинг кафе",
			Subtitle: "Группировка кафе по рейтингу",
		}),
		charts.WithTooltipOpts(opts.Tooltip{
			Show:      opts.Bool(true),
			Trigger:   "item",
			Formatter: "{b}: {c} ({d}%)", // Показывает имя, значение и процент
		}),
		charts.WithLegendOpts(opts.Legend{
			Show:   opts.Bool(true),
			Top:    "15%",
			Left:   "left",
			Orient: "vertical",
		}),
		charts.WithGridOpts(opts.Grid{
			Top:  "25%", // например, 25% или в пикселях "150px" — подберите удобное значение
			Left: "30%",
		}),
	)

	pie.AddSeries("Рейтинг кафе", pieData).
		SetSeriesOptions(
			charts.WithPieChartOpts(opts.PieChart{
				Radius:   []string{"40%", "70%"}, // Кольцевая диаграмма
				RoseType: "radius",               // Вариация по радиусу
			}),
			charts.WithLabelOpts(opts.Label{
				Show:      opts.Bool(true),
				Formatter: "{b}: {c}",
			}),
		)

	f, err := os.Create("pie_chart.html")
	if err != nil {
		log.Fatalf("Не удалось создать файл: %v", err)
	}
	defer f.Close()

	err = pie.Render(f)
	if err != nil {
		log.Fatalf("Не удалось отрендерить график: %v", err)
	}

	log.Println("Круговая диаграмма успешно сохранена в pie_chart.html")

	cmd := exec.Command("google-chrome-stable", "/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/analysis/cmd/pie_chart.html")
	err_ := cmd.Run()
	if err_ != nil {
		log.Fatalf("Не удалось запустить браузер: %v", err)
	}
}

func RelationGraphCourierCafe() {
	dbURL := "postgres://postgres:gbfh78psql@localhost:5432/hw_mipt_db_2025"
	data := ScanDBCourierCafeRelation(dbURL)

	nodeMap := make(map[string]struct{}) // для проверки наличия узла
	nodes := make([]opts.GraphNode, 0)
	links := make([]opts.GraphLink, 0)

	// Добавим категории для узлов: 0 - Курьеры, 1 - Кафе
	categories := []*opts.GraphCategory{
		{Name: "Courier"},
		{Name: "Cafe"},
	}

	// Добавляем узлы и ссылки
	addNode := func(name string, category int) {
		if _, exists := nodeMap[name]; !exists {
			nodeMap[name] = struct{}{}
			nodes = append(nodes, opts.GraphNode{
				Name:       name,
				Category:   category,
				SymbolSize: 20, // размер узла (можно менять)
			})
		}
	}

	for _, rel := range data {
		courierName := fmt.Sprintf("Courier #%d", rel.CourierId)
		cafeName := fmt.Sprintf("Cafe #%d", rel.CafeId)

		addNode(courierName, 0)
		addNode(cafeName, 1)

		// Создаем ребро из курьера в кафе
		links = append(links, opts.GraphLink{
			Source: courierName,
			Target: cafeName,
		})
	}

	// Создаем граф
	graph := charts.NewGraph()

	graph.SetGlobalOptions(
		charts.WithInitializationOpts(opts.Initialization{
			Theme:  types.ThemeWesteros,
			Width:  "1800px",
			Height: "1400px",
		}),
		charts.WithTitleOpts(opts.Title{
			Title:    "Связи Курьеров и Кафе",
			Subtitle: "Граф связей",
		}),
		charts.WithLegendOpts(opts.Legend{
			Show:   opts.Bool(true),
			Data:   []string{"Courier", "Cafe"},
			Top:    "20%",
			Left:   "left",
			Orient: "vertical",
		}),
		charts.WithTooltipOpts(opts.Tooltip{
			Show:    opts.Bool(true),
			Trigger: "item",
		}),
		charts.WithGridOpts(opts.Grid{
			Top: "25%", // например, 25% или в пикселях "150px" — подберите удобное значение
		}),
	)

	graph.AddSeries("relation", nodes, links,
		charts.WithGraphChartOpts(opts.GraphChart{
			Layout:             "force",
			FocusNodeAdjacency: opts.Bool(true),
			Categories:         categories,
			Roam:               opts.Bool(true),
			Force: &opts.GraphForce{
				Repulsion:  1000, // Увеличиваем отталкивание
				Gravity:    0.1,  // Уменьшаем гравитацию (чтобы узлы не скучивались в центре)
				EdgeLength: 200,  // Увеличиваем длину связей
			},
		}),
		charts.WithLabelOpts(opts.Label{Show: opts.Bool(true)}),
	)

	f, err := os.Create("courier_cafe_graph.html")
	if err != nil {
		log.Fatalf("Ошибка создания файла: %v", err)
	}
	defer f.Close()

	err = graph.Render(f)
	if err != nil {
		log.Fatalf("Ошибка рендеринга графа: %v", err)
	}

	log.Println("Граф связей успешно сохранен в courier_cafe_graph.html")

	cmd := exec.Command("google-chrome-stable", "/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/analysis/cmd/courier_cafe_graph.html")
	err_ := cmd.Run()
	if err_ != nil {
		log.Fatalf("Не удалось запустить браузер: %v", err)
	}
}
