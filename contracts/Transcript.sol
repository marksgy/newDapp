pragma solidity ^0.4.19;


contract Transcript{

    struct Registrar{
        address registrar;
        bytes32 name;
        bytes32 id;
        bool flag;

    }

    struct Professor{
        address professor;
        bytes32 name;
        bytes32 id;
        bool flag;
    }

    struct Student{
        address student;
        bytes32 name;
        bytes32 id;
        uint courseNum;
        bool flag;
    }

    struct Course{
        bytes32 name;
        bytes32 id;
        bytes32 professor;
        byte score;
        bool flag;
        bool selected;
        bool flagStud;
        bool flagRegis;
        bool flagProf;

    }

    address public admin;
    uint public courseLimit;
    mapping(bytes32 => mapping(bytes32 => Course)) public courseSelection;//学生id => (课程id => 课程)s
    mapping(bytes32 => Course) public courses;//课程id => 课程
    mapping(address => Professor) public professors;
    mapping(address => Student) public students;
    mapping(address => Registrar) public registrars;

    mapping(bytes32 => bool) public registrarIDs;
    mapping(bytes32 => bool) public professorIDs;
    mapping(bytes32 => bool) public studentIDs;
    mapping(bytes32 => bool) public courseIDs;

    //合约的构造函数，录入创始者的地址
    function Transcript(){
        admin=msg.sender;
    }

    //初始化
    //录入registrar的id
    //操作成功条件：1.管理员进行 2.该registrar的id没有被录入
    function init(bytes32[] registrarID) public returns(bool){
        if(msg.sender == admin ){
            for (uint i = 0; i< registrarID.length; i++){
                bytes32 id=registrarID[i];
                if(!registrarIDs[id]){
                    registrarIDs[id]=true;
                }
            }
	    return true;
        }
    }

    //registrar注册
    //注册成功条件：1.registrarIDs中存在其id 2.以前没有被注册过
    function initRegistrar(bytes32 id, bytes32 name) public {
        address add=msg.sender;

        if(registrarIDs[id] && !registrars[add].flag){
            registrars[add]=Registrar({
                registrar:add,
                name:name,
                id:id,
                flag:true
                });
        }

    }


    //录入professor,student,course的id
    //录入成功条件：1.registrar进行 2.professor,student,course的id没有被录入过
    function fillIDs(bytes32[] professorID, bytes32[] studentID, bytes32[] courseID) public {
        if(registrars[msg.sender].flag){
            for (uint i = 0; i< professorID.length; i++){
                bytes32 id=professorID[i];
                if(!professorIDs[id]){
                    professorIDs[id]=true;
                }
            }

            for (i = 0; i< studentID.length; i++){
                id=studentID[i];
                if(!studentIDs[id]){
                    studentIDs[id]=true;
                }
            }

            for (i = 0; i< courseID.length; i++){
                id=courseID[i];
                if(!courseIDs[id]){
                    courseIDs[id]=true;
                }
            }

        }

    }
    //设置课程数量限制
    function setLimit(uint limit) public{
        if(registrars[msg.sender].flag){
            courseLimit=limit;
        }
    }
    //professor注册
    //注册成功条件：1.professorIDs中存在其id 2.以前没有被注册过
    function initProfessor(bytes32 id, bytes32 name) public {
        address add=msg.sender;

        if(professorIDs[id] && !professors[add].flag){
            professors[add]=Professor({
                professor:add,
                name:name,
                id:id,
                flag:true
                });
        }

    }

    //student注册
    //注册成功条件：1.studentIDs中存在其id 2.以前没有被注册过
    function initStudent(bytes32 id, bytes32 name) public {
        address add=msg.sender;

        if(studentIDs[id] && !students[add].flag){
            students[add]=Student({
                student:add,
                name:name,
                id:id,
                flag:true,
                courseNum:0
                });
        }

    }

    //course注册
    //注册成功条件：1.courseIDs中存在其id 2.以前没有被注册过
    function initCourse(bytes32 id, bytes32 name , bytes32 professor) public {
        if(professors[msg.sender].flag){
            if(courseIDs[id] && !courses[id].flag){
                courses[id]=Course({
                    name:name,
                    id:id,
                    professor:professor,
                    score:0,
                    flag:true,
                    selected:false,
                    flagStud:false,
                    flagRegis:false,
                    flagProf:false
                    });
            }
        }

    }

    //选课
    function courseSelect(bytes32 id) public{
        address add=msg.sender;
        if(courses[id].flag){
            Course course=courses[id];
        }else{
            return;
        }
        if(students[add].flag){
            bytes32 studentID=students[add].id;

            if(!courseSelection[studentID][id].selected){
                if(students[add].courseNum>=courseLimit){
                    return;
                }

                courseSelection[studentID][id]=Course({
                    name:course.name,
                    id:id,
                    professor:course.professor,
                    score:0,
                    flag:true,
                    selected:true,
                    flagStud:false,
                    flagRegis:false,
                    flagProf:false
                    });
                students[add].courseNum++;
            }
        }

    }

    //退选(drop)
    function courseDrop(bytes32 id) public{
        address add=msg.sender;
        if(!courses[id].flag){
            return;
        }else if(!courseSelection[studentID][id].selected){
            return;
        }
        if(students[add].flag){
            bytes32 studentID=students[add].id;
            delete courseSelection[studentID][id];
            students[add].courseNum--;
        }

    }

    //撤回(withdraw)
    function courseWithdraw(bytes32 id) public{
        address add=msg.sender;

        if(!courses[id].flag){
            return;
        }else if(!courseSelection[studentID][id].selected){
            return;
        }

        if(students[add].flag){
            bytes32 studentID=students[add].id;
            courseSelection[studentID][id].score='W';
        }
    }

    //对指定学生的指定课程打分
    function courseScore(bytes32 studentID,bytes32 courseID,byte score) public{
        address add=msg.sender;
        if(!courses[courseID].flag){
            return;
        }else if(!courseSelection[studentID][courseID].selected){
            return;
        }
        if(professors[add].flag){
            courseSelection[studentID][courseID].score=score;
        }
    }

    //改分数
    function changeScore(bytes32 studentID,bytes32 courseID,byte score) public{
        address add=msg.sender;
        if(!courses[courseID].flag){
            return;
        }else if(!courseSelection[studentID][courseID].selected){
            return;
        }else if(courseSelection[studentID][courseID].score==0){
            return;
        }
        Course course=courseSelection[studentID][courseID];
        if(students[add].flag){
            course.flagStud=true;
        }
        if(professors[add].flag){
            course.flagProf=true;
        }
        if(registrars[add].flag){
            course.flagRegis=true;
        }
        if(course.flagRegis&&course.flagProf&&course.flagStud){
            course.score=score;
            course.flagRegis=false;
            course.flagProf=false;
            course.flagStud=false;
        }
    }

}



