package ORM

func GetMostPopularClient(dbURL string, table_name string) int {
	orders := ScanDBTable(dbURL, table_name)

	countMap := make(map[int]int, 1000)

	for _, value := range orders {
		countMap[value.ClientId] = countMap[value.ClientId] + 1
	}

	var maxClientId int
	maxCount := 0
	for clientId, count := range countMap {
		if count > maxCount {
			maxCount = count
			maxClientId = clientId
		}
	}

	return maxClientId
}

func GetMostUnpopularClient(dbURL string, table_name string) int {
	orders := ScanDBTable(dbURL, table_name)

	countMap := make(map[int]int, 1000)

	for _, value := range orders {
		countMap[value.ClientId] = countMap[value.ClientId] + 1
	}

	var minClientId int
	for key := range countMap {
		minClientId = key
	}

	minCount := countMap[minClientId]
	for clientId, count := range countMap {
		if count < minCount {
			minCount = count
			minClientId = clientId
		}
	}

	return minClientId
}
