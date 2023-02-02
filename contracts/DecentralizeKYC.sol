// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.5;

contract BankKYC{

address admin;

constructor(){
    admin=msg.sender;
}

modifier onlyAdmin{
    require(msg.sender==admin,"only admin can access");
    _;
}
    struct bankInfo{
        string bankName;
        address bankAddress;
        uint256 KYCCount;
        bool canAddCustomer;
        bool canDoKYC;
    }
    struct customerInfo{
        string customerName;
        address customerAddress;
        string customerData;
        bool KYCStatus;
    }

    mapping(address => bankInfo) banks;
    mapping(string => customerInfo) customers;

    function addNewBank(string memory _bankName,address _bankAddress) public onlyAdmin {
        banks[_bankAddress]= bankInfo(_bankName,_bankAddress,0,true,true);
    }

    function addNewCustomer(string memory _customerName,string memory _customerData) public {
        require(banks[msg.sender].canAddCustomer,"addnewcustomer is block by admin");
        customers[_customerName]= customerInfo(_customerName,msg.sender,_customerData,false);
    }

     function checkKYCOfExistingCustomer(string memory _customerName) public view returns(bool){
        return(customers[_customerName].KYCStatus);
    }

    function blockBankFromAddingCustomer(address _bankAddress) public onlyAdmin {
        banks[_bankAddress].canAddCustomer=false;
    }

    function blockBankFromDoingKYC(address _bankAddress) public onlyAdmin {
        banks[_bankAddress].canDoKYC=false;
    }

    function allowBankFromAddingCustomer(address _bankAddress) public onlyAdmin {
        banks[_bankAddress].canAddCustomer=true;
    }

    function allowBankFromDoingKYC(address _bankAddress) public onlyAdmin {
        banks[_bankAddress].canDoKYC=true;
    }

    function performKYC(string memory _customerName) public {
        require(banks[msg.sender].canDoKYC,"bank is block to do customer KYC");
        customers[_customerName].KYCStatus=true;
    }

    function viewCustomer(string memory _customerName) public view returns(string memory, bool){
       return(customers[_customerName].customerData,customers[_customerName].KYCStatus);
    }
    




}