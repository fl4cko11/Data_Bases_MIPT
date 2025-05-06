package main

import (
	"analysis/internal/analysis_funcs"
	"analysis/internal/queries"
)

func main() {
	queries.InsertRandomOrders(5)
	analysis_funcs.BarChartQuantityItem()
	analysis_funcs.PieChartCafeRating()
	analysis_funcs.RelationGraphCourierCafe()
}
