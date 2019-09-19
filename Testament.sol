pragma solidity >=0.4.22 <0.6.0;

contract Testament {

    //event sendDoxhash(string doxHash);


    //Document Structure
    struct Doc {
        uint Id;
        bool pshared;
        string doxash;
        uint256 duration;

    }

    //CheckInTime Structure
    struct checkInTime{
        uint256 Id;
        uint256 Time;
        string ipaddress;
    }


    //Single Document Object
    Doc Document;

    //Owner Address
    address testator;

    //Witness Address
    address witness;

    //Application Delegate Address
    address delegate;


    //CheckInTime Logs
    checkInTime[] checkInTimes;

    //Last Check In Time Address
    uint256 currentCheckInTime;

    
    //For Random Number Generation
    uint Digits = 16;

    //For Random Number Generation
    uint Modulus = 10 ** Digits;



     constructor(address _witness,string memory _ipaddress) public {

        testator=msg.sender;

        witness=_witness;

        //Consider Witness as Delegate initially
        delegate=_witness;

        //Log New Record
        checkInTimes.push(checkInTime(currentCheckInTime+1,now,_ipaddress));
        //Set Last CheckInTime
        currentCheckInTime=now;

    }


    //Update IPFS Document Hash
    function pushDocumentHash(string memory doxash,uint256 dr) public {

        require(msg.sender==testator);
        
        Document.doxash=doxash;

        Document.Id= _generateRandomId(doxash);

        Document.pshared=false;

        Document.duration=dr;

    }

    //Testator Check Ins Periodically

    function checkIn(string memory _ipaddress)public 

    {
        require(msg.sender==testator);

        checkInTimes.push(checkInTime(currentCheckInTime+1,now,_ipaddress));

        currentCheckInTime=now;

    }

    //Called By Application to check 

    function getCheckInTime() public view returns(uint256){

        return currentCheckInTime;
        
    }

    //Called by Application If Check In exceeds Duration 

    function PullDox() public view returns(string memory hash) {

        if((now-currentCheckInTime)>=Document.duration)
        {
            return Document.doxash;
            //emit sendDoxhash(Document.doxash);
        }
        
    }

    //Testator can update Delegate 

    function UpdateDelegate(address _newaddress) public {

        require(msg.sender==testator);

        delegate=_newaddress;

    }


    //generate random hash for Document Id

    function _generateRandomId(string memory _str) private view returns (uint) {

        uint rand = uint(keccak256(abi.encodePacked(_str)));

        return rand % Modulus;

    }

}