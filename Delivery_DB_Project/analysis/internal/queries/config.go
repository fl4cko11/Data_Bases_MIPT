package queries

type HOrdersRow struct {
	OrderId   int
	OrderItem string
	ClientId  int
	Quantity  int
	Date      string
	CafeId    int
	CourierId int
}
