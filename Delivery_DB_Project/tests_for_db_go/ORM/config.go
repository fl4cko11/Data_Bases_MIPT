package ORM

import "time"

type HOrdersRow struct {
	OrderId   int
	OrderItem string
	ClientId  int
	Quantity  int
	Date      time.Time
	CafeId    int
	CourierId int
}
