package DbTests

type queryTests struct {
	fileName       string
	expectedValue  any
	resultCheckCol int
}

type procedureTests struct {
	TestName    string
	CallCommand string
}
