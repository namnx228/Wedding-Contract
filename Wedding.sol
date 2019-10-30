pragma experimental ABIEncoderV2;
pragma solidity >=0.4.0 <0.7.0;
contract Wedding{
    uint256 constant NULL = uint256(0);
    struct Guest{
        string name;
        string email;
        uint256 couponCode;
        uint256 ticket;
        bool decision;
        address etherumAddress;
    }
    struct Objection{
        string reason;
        string postedPersonName;
        address postedPersonAddress;
        uint256 objectionDate;
        uint256 numOfPositiveVote;
    }
    enum ObjectionStatus {
        None,
        Pending,
        Completed,
        Rejected // We may need this someday!?
    }
    enum WeddingStatus {
        Pending,
        Completed,
        Terminated,
        PendingWithObjection
    }

    string eventName;
    string coupleName;
    string location;
    WeddingStatus weddingStatus; //{Pending / Completed / Terminated / PendingWithObjection }
    uint weddingTimeStart;
    uint weddingTimeEnd;

    mapping (string => uint256) ticketMapping;
    mapping (string => uint256) couponMapping;
    mapping (string => bool) participationRecord;
    mapping (uint256 => int8) votingData;
    string private constant ticket = "123yc346tb349v3";
    uint paticipantCount;
    
    Guest[] listOfGuest;
    
    ObjectionStatus objectionStatus = ObjectionStatus.None;
    Objection object;
    uint8 objectionVotingThreshold;
    mapping (address => string) address2name;
    mapping (string => uint) name2index;
    address wifeAddress;
    address husbandAddress;
    bool doesWifeAgreeToComplete = false;
    bool doesHusbandAgreeToComplete = false;

    constructor(address wifeAddress1, address husbandAddress1, Guest[] memory guestList ) public {
        eventName = "Khiem - Ngoc wedding";
        coupleName = "Khiem - Ngoc";
        location = "Moholt";
        weddingStatus = WeddingStatus.Pending;
        
        weddingTimeStart = 1571961600; // 10/25/2019 -- 0:0:0
        weddingTimeEnd = 1572307200; // 10/29/2019 -- 0:0:0
        paticipantCount = 0;
        
        wifeAddress = wifeAddress1;
        husbandAddress = husbandAddress1;
        
        for(uint i = 0; i < guestList.length; i++){
            listOfGuest.push(guestList[i]);
            address2name[guestList[i].etherumAddress] = guestList[i].name;
            name2index[guestList[i].name] = i;
        }
        
        ticketGeneration();

        objectionVotingThreshold = 50; //50%
    }
    modifier checkWeddingStage(WeddingStatus expectedWeddingStatus, string memory message){
      require(expectedWeddingStatus == weddingStatus, message);
      _;
    }

    modifier checkParticipationRecord(string memory name, string memory message){
        require(participationRecord[name] == false, message);
        _;
    }

    modifier isBigDay(){
        uint timestamp=block.timestamp;
      require(weddingTimeStart <= block.timestamp && block.timestamp <= weddingTimeEnd, "Today is not the bigday");
      _;
    }

    modifier authenticate(string memory name, string memory message){
      
      require(bytes(name).length != 0 && compareStrings(address2name[msg.sender], name), message);
      //require();
      _;
    }
    
    function getGuest(string  memory guestname, int256  guestticket) view private returns (int){
      for (uint i = 0; i < listOfGuest.length; i++){
        string memory tmpName = listOfGuest[i].name;
        uint tmpTicket = listOfGuest[i].ticket;
        if (compareStrings(tmpName, guestname) &&  tmpTicket ==  uint(guestticket)){
          return int(i);
        }
      }
      return -1;
    }
    function checkIn(string memory guestname, int256 guestticket) view private returns(bool){
       int guestIndex = getGuest(guestname, guestticket);
       if (guestIndex == -1 )
         return false;
       return true;
    }

    function login(string memory guestname, int256  guestticket) checkWeddingStage(WeddingStatus.Pending, "Go out") 
                  isBigDay
                  authenticate(guestname,"This address is not allowed to be involed in this contract" ) view public returns (string memory){
       if (checkIn(guestname, guestticket))
          return "Welcome to the wedding";
       return "You don't have the ticket or you are not invited";
    }
    
    
    // Accept function
    function acceptTheWedding(string memory name) 
        checkWeddingStage(WeddingStatus.Pending,"You are not allowed to accept the invitation anymore.") 
        checkParticipationRecord(name,"You have already confirmed whether you will participate or not.")
        authenticate(name, "This address is not allowed to join the contract") public {
        uint index = name2index[name];
        ticketMapping[name] = listOfGuest[uint256(index)].ticket;
        participationRecord[name] = true;
        paticipantCount++;
    }

    function getWeddingInfo(string memory name) view public returns(string memory, string memory, //Name of the couple
                                               string memory, string memory, // Location
                                               string memory, string memory, // Date
                                               string memory, uint, // Num of paticipant
                                               string memory, string memory){ // Status
       require(bytes(name).length != 0 && 
                    (compareStrings(address2name[msg.sender], name) 
                    || msg.sender == wifeAddress || msg.sender == husbandAddress), "You cannot view this information");
       return ("Name of the couple: ", coupleName, 
              "Location: ", location, 
              "Date: ", "11/04/2019",
              "Number of paticipants: ", paticipantCount,
              "Status of the wedding: ", getWeddingStatus() );
    }

    // ticket generation
    function ticketGeneration() private {
        for (uint256 i = 0; i < listOfGuest.length ; i++){
            listOfGuest[i].ticket = random(i,"ticket");
        }
    }
    function getGuestList() view public returns(Guest[] memory){
       return listOfGuest;

    }

    function getWeddingStatus() view private returns (string memory){
      if (weddingStatus == WeddingStatus.Pending)
        return "Pending";
      if (weddingStatus == WeddingStatus.PendingWithObjection)
        return "PendingWithObjection";
      if (weddingStatus == WeddingStatus.Completed)
        return "Completed";

      return "Terminated";
    }

    // show guest ticket details
    function getGuestTicket(string memory name) view public returns (uint256){
        return ticketMapping[name];
    }
    
    // random number generation
    function random(uint256 index, string memory ticket_coupon) private view returns (uint32) {
        string memory guestName = listOfGuest[index].name;
        return uint32(uint256(sha256(abi.encodePacked(ticket_coupon, guestName))) % 4294967295);
    }
    
    function opposeWedding(string memory reason, string memory name) authenticate(name, "Unauthorized!")public {
        require(objectionStatus == ObjectionStatus.None, "Relax, there has been arealdy an objection, do you like to vote?");
        
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        object = Objection({reason: reason, postedPersonName: name, postedPersonAddress: msg.sender, objectionDate: now, numOfPositiveVote: 1});
        
        votingData[providedName] = 1;
        if (object.numOfPositiveVote * 100 / listOfGuest.length > objectionVotingThreshold) {
            objectionStatus = ObjectionStatus.Completed;
            weddingStatus = WeddingStatus.Terminated;
        } else {
            objectionStatus = ObjectionStatus.Pending;
            weddingStatus = WeddingStatus.PendingWithObjection;    
        }
        
    }
    
    function getObjectionStatus(string memory name) 
                                authenticate(name, "Unauthorized!") public view returns (string memory, string memory, uint256, uint256, uint8){
        
        if (objectionStatus == ObjectionStatus.Pending) {
            return ("Pending Objection", object.reason, object.numOfPositiveVote, listOfGuest.length, objectionVotingThreshold);
        } else if (objectionStatus == ObjectionStatus.Rejected) {
            return ("Rejected Objection, Everything is still good!", object.reason, object.numOfPositiveVote, listOfGuest.length, objectionVotingThreshold);
        } else if (objectionStatus == ObjectionStatus.Completed) {
            return ("Completed Objection, DONE!", object.reason, object.numOfPositiveVote, listOfGuest.length, objectionVotingThreshold);
        }
        return ("Everything is still good, I guess!", "", 0, 0, 0);

    }
    
    function getCurrentVote(string memory name) 
                            authenticate(name, "You cannot vote with wrong credential") view public returns(int8, uint256) {
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return (votingData[providedName], object.numOfPositiveVote);
    }

   function voteForObjection(string memory name, bool wannaStop)
                              authenticate(name, "You cannot vote with wrong credential") public {            
        
        require(objectionStatus == ObjectionStatus.Pending, "There must be an objection created or not yet terminated to be able to vote!");
        require(object.postedPersonAddress != msg.sender, "Sorry, Voting option is not supported for the objection creator!!");
        
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        int8 currentVote = votingData[providedName];
        if (wannaStop) {
            votingData[providedName] = 1;
            if (currentVote != 1) {
                object.numOfPositiveVote += 1;
            }
        } else {
            votingData[providedName] = -1;
            if (currentVote != -1) {
                object.numOfPositiveVote -= 1;
            }
        }
        
        if (object.numOfPositiveVote * 100 / listOfGuest.length > objectionVotingThreshold) {
            weddingStatus = WeddingStatus.Terminated;
            objectionStatus = ObjectionStatus.Completed;
        }
    }
    
    modifier checkCoupleAddress(){
      require(weddingStatus == WeddingStatus.Pending || weddingStatus == WeddingStatus.PendingWithObjection, "Wedding ceremony is not happening");
      require(block.timestamp > weddingTimeEnd, "Too soon to complete the wedding");
      _;
    }
    
    function completeTheWedding() checkCoupleAddress public {
        require(msg.sender == wifeAddress || msg.sender == husbandAddress, "Unauthorized!");
        
        if (msg.sender == wifeAddress) {
            doesWifeAgreeToComplete = true;
        }
        
        if (msg.sender == husbandAddress) {
            doesHusbandAgreeToComplete = true;
        }
        
        if (doesHusbandAgreeToComplete && doesWifeAgreeToComplete) {
            weddingStatus = WeddingStatus.Completed;
        }
    }


    function terminateTheWedding()  public {
        if  (! (msg.sender == wifeAddress || msg.sender == husbandAddress))
            return ;
       weddingStatus = WeddingStatus.Terminated;
  
   } 
   
    ////------------------------------------------------ Utility Functions -----------------------------------
    function compareStrings (string memory a, string memory b) private view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}

