package DbTests

type queryTests struct {
	fileName       string
	expectedValue  any
	resultCheckCol int
}

type procedureTests struct {
	testName    string
	callCommand string
}

func startsWithSelect(query string) bool {
	// Простая проверка, чтобы понять, SELECT это или нет (можно сделать строчными для безопасности)
	return len(query) >= 6 && (query[:6] == "SELECT" || query[:6] == "select")
}
