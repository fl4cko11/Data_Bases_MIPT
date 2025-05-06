package main

import (
	"analysis/internal/analysis_funcs"
	"analysis/internal/queries"
)

func main() {
	queries.InsertRandomOrders(5)
	analysis_funcs.Graph()
}
