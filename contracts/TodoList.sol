// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract TodoList {
    address public owner;

    enum Status { None, Created, Edited, Done }

    struct Todo {
        string title;
        string description;
        Status status;
    }

    Todo[] public todos;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner () {
        require(msg.sender == owner, "You are not allowed");
        _; // execute the next code
    }

    modifier validAddress() {
        require(msg.sender != address(0), "Zero address ia not allowed");
        _;
    }
    
    event TodoCreated(string title, Status status);
    event TodoUpdated(string title, Status status);

    function createTodo(string memory _title, string memory _desc) public onlyOwner validAddress returns(bool) {
        Todo memory myTodo;

        myTodo.title = _title;
        myTodo.description = _desc;
        myTodo.status = Status.Created;

        todos.push(myTodo);

        emit TodoCreated(_title, Status.Created);

        return true;
    }

    function updateTodo(uint8 _index, string memory _title, string memory _desc) external  onlyOwner validAddress {
        require(_index < todos.length, "Index is out of bound");

        Todo storage myTodo = todos[_index];  
        myTodo.title = _title;     
        myTodo.description = _desc;     
        myTodo.status = Status.Edited;

        emit TodoUpdated(_title, Status.Edited);    
    }

    function getTodo(uint8 _index) external view validAddress returns (string memory, string memory, Status){
        require(_index < todos.length, "Todo does not exist!");

        Todo memory myTodo = todos[_index];
        return (myTodo.title, myTodo.description, myTodo.status);
    }

    function getAllTodos() external view validAddress returns (Todo[] memory) {
        return todos;
    }

    function todoCompleted(uint8 _index) external onlyOwner validAddress returns (bool) {
        require(_index < todos.length, "Out of bound!");

        Todo storage myTodo = todos[_index];
        myTodo.status = Status.Done;

        return true;
    }

    function deleteTodo(uint8 _index) external onlyOwner validAddress {
        require(_index < todos.length, "Out of bound!");

        todos[_index] = todos[todos.length -1];
        todos.pop();
    }
}