program ZoopasRev;

uses crt;
    const arrLimit = 30;

    type 

        Officers = record
            id : integer;
            nip:string[5];
            firstName,lastName,position:string[10];        // Sort By FirstName ASC & DESC --> Selection       Position:: 1. Pengasuh   2. Penjaga    3. Pengawas
        end;

        Jobs = record
            id : integer;
            startHours,finishHours,totalHours:integer;     // Sort By Work Hours ASC & DESC --> Insertion
            location:string;        //  1. Sector I   2. Sector II    3. Sector III
        end;

        arrOfficers = array[1..arrLimit]of Officers;
        arrJobs     = array[1..arrLimit]of Jobs;

    var arrLength,inc,flag        : integer;
        terminate, editData, deleteData, found : boolean;
        officer,tempOfficer       : arrOfficers;
        job,tempJob               : arrJobs;

    function countWorkHours(rec1,rec2 : integer) : integer;
    begin
        countWorkHours:= rec2-rec1;
    end;

    function whichSort(flag : integer ) : integer;
    begin
        writeln('Which Sort Type Would You Want to See?');
        writeln('1. Ascending (Terkecil - Terbesar)');
        writeln('2. Descending (Terbesar - Terkecil)');
        writeln;

        write('Answers : ');
        readln(flag);
        writeln('---------------------------------');
        
        whichSort:=flag;
    end;

    function whichSearch(flag : integer ) : integer;
    begin
        writeln('==================================================');
        writeln('               SEARCH OFFICERS DATA');
        writeln('==================================================');
        writeln;

        if (arrLength = 0) then 
        begin
            write ('Officers Data is Empty!');
            readln;
            whichSearch:=0;
        end;

        if(arrLength >= 1) then
        begin
            writeln('Which Search Type Would You Want to See?');
            writeln('1. Search By Name ');
            if(editData = False) AND (deleteData = False) then
                writeln('2. Search By Location (Sector I, Sector II, Sector III)');
            writeln;

            write('Answers : ');
            readln(flag);
            writeln('---------------------------------');
            
            whichSearch:=flag;
        end;
    end;

    procedure SwapVarOfficer(var rec1, rec2 : Officers);
    var temp : Officers;
    begin
        temp := rec1;
        rec1 := rec2;
        rec2 := temp;
    end;

    procedure SwapVarJob(var rec1, rec2 : Jobs);
    var temp : Jobs;
    begin
        temp := rec1;
        rec1 := rec2;
        rec2 := temp;
    end;

    procedure WorkHourSort(var officer : arrOfficers; var job : arrJobs);
    //This Procedure using Insertion Sort Alogrithm
    var pass : integer;
        tempJobs : Jobs;
        tempOfficers : Officers;
    begin
        inc := 0;
        pass := 1;

        while (pass <= arrLength-1) do
        begin
            inc:= pass + 1;

            tempJobs := job[inc];
            tempOfficers := officer[inc];

            while (inc > 1) and (job[inc].totalHours < job[inc-1].totalHours ) and (flag = 1) do
            begin
                SwapVarOfficer(officer[inc],officer[inc-1]);
                SwapVarJob(job[inc],job[inc-1]);
                inc:=inc-1;
            end;
                
            while (inc > 1) and (job[inc].totalHours > job[inc-1].totalHours ) and (flag = 2) do
            begin
                SwapVarOfficer(officer[inc],officer[inc-1]);
                SwapVarJob(job[inc],job[inc-1]);
                inc:=inc-1;
            end;

            job[inc] := tempJobs;
            officer[inc] := tempOfficers;
            pass := pass + 1;
        end;
    end;

    procedure NameSort(var officer : arrOfficers; var job : arrJobs);
    //This Procedure using Selection Sort Algorithm
    var min,inc,pass : integer;
    begin
        pass := 1;

        while (pass <= arrLength-1) do
        begin
            inc:= 1 + pass;
            min := pass;
            while (inc <= arrLength) do
            begin
                if (lowercase(officer[min].firstName[1]) > lowercase(officer[inc].firstName[1])) and (flag = 1) then 
                    begin
                    SwapVarOfficer(officer[min],officer[inc]);
                    SwapVarJob(job[min],job[inc]);
                    end

                else if (lowercase(officer[min].firstName[1]) < lowercase(officer[inc].firstName[1])) and (flag = 2) then 
                    begin
                    SwapVarOfficer(officer[min],officer[inc]);
                    SwapVarJob(job[min],job[inc]);
                    end;
                
                inc:=inc+1;
            end;
            pass:=pass+1;
        end;
    end;

    procedure InsertDataList(values : integer);
    begin
            // Input Officer Array
            write('Identification Numb[5]   : ');
            readln(officer[values].nip);
            
            write('First Name[10]           : ');
            readln(officer[values].firstName);
            
            write('Last Name[10]            : ');
            readln(officer[values].lastName);

            write('Job Position(Pengasuh,Penjaga,Pengawas) : ');
            readln(officer[values].position);         

            //Input Jobs Array
            write('Job Location(Sector I, Sector II, Sector III) : ');
            readln(job[values].location);
            
            repeat
                write('Start Hours(0-23)h       : ');
                readln(job[values].startHours);
            until (job[values].startHours > 0) and (job[values].startHours < 24);

            repeat
                write('Finish Hours(0-24)h      : ');
                readln(job[values].finishHours);
            until (job[values].finishHours > job[values].startHours) and (job[values].finishHours <=24);

            //Direct Assign Value
            officer[values].id := values; //Insert Officer ID
            job[values].id := values; //Insert Job ID
            job[values].totalHours := countWorkHours(job[values].startHours,job[values].finishHours);  //Insert Work Hours
    end;

    procedure ShowData(officer : arrOfficers; job : arrJobs);
    var inc : integer;
    begin
        clrscr;
        inc:=1;
        while ( inc <= arrLength) do
        begin
            writeln('NIP              :', officer[inc].nip);
            writeln('Full Name        :', officer[inc].firstName,' ',officer[inc].lastName);
            writeln('Job Position     :', officer[inc].position);   

            writeln('Current Location :', job[inc].location);
            writeln('Start Hours      :', job[inc].startHours);
            writeln('Finish Hours     :', job[inc].finishHours);
            writeln('Work  Hours      :', job[inc].totalHours);
            
            writeln('---------------------------------');

            inc := inc+1;
            readln;
        end;
        readln;
    end;

    procedure showSearch(officer : arrOfficers; job : arrJobs; inc : integer);
    begin
        writeln;
        writeln('NIP              :', officer[inc].nip);
        writeln('Full Name        :', officer[inc].firstName,' ',officer[inc].lastName);
        writeln('Job Position     :', officer[inc].position);   

        writeln('Current Location :', job[inc].location);
        writeln('Start Hours      :', job[inc].startHours);
        writeln('Finish Hours     :', job[inc].finishHours);
        writeln('Work  Hours      :', job[inc].totalHours);
        writeln('---------------------------------');
    end;

    procedure SearchByName(var officer : arrOfficers;var job : arrJobs; var inc : integer);
    var key : string;
    begin
        inc := 1;
        write('Masukkan Nama Pegawai : ');
        readln(key);

        while (inc <= arrLength) and (officer[inc].firstName <> key) do 
            inc:=inc+1;

        if (officer[inc].firstName = key) then 
        begin
            showSearch(officer,job,inc);
            found := True;
        end
        else
        begin 
            writeln('Data Not Found!');
            found := False;
        end;
    end;

    procedure SearchByLocation(var officer : arrOfficers;var job : arrJobs);
    var key : string;
        inc,match : integer;
    begin
        inc := 1;
        write('Masukkan Lokasi Kerja : ');
        readln(key);

        while (inc <= arrLength) do
        begin
            if (job[inc].location = key) then
                showSearch(officer,job,inc)
            else match := 1;
            inc:=inc+1;
        end;
        
        if(match <> 1) then writeln('Data Not Found!');
    end;

    procedure copyData(var tempOfficer : arrOfficers; var tempJob : arrJobs);
    var inc : integer;
    begin
        inc := 1;

        while (inc <= arrLength) do
        begin
            tempOfficer[inc] := officer[inc]; //Insert Temp Officer Data
            tempJob[inc]     := job[inc];     //Insert Temp Job Data
            inc := inc + 1;
        end;
    end;
    
    procedure EditOfficerData(officer : arrOfficers; job : arrJobs; inc : integer);
    var run : char;
    begin
        if (found = True) then
        begin
            writeln('Are You Sure Want to Edit Data of "', officer[inc].firstName, '"');
            write('Answer(Y/N) : ');
            readln(run);

            if(upcase(run) = 'Y' ) then
            begin
                InsertDataList(inc);
                writeln('Data Saved!');
            end;
        end;
        readln;
    end;

    procedure DeleteOfficerData(var officer : arrOfficers; var job : arrJobs; inc : integer);
    var run : char;
    begin
        if (found = True) then
        begin
            writeln('Are You Sure Want to Delete Data of "', officer[inc].firstName, '"');
            write('Answer(Y/N) : ');
            readln(run);

            if(upcase(run) = 'Y' ) then
            begin
    
                while (inc <= arrLength) do
                begin
                    officer[inc] := officer[inc+1]; //Replace Officer Data
                    job[inc]     := job[inc+1];     //Replace Job Data
                    
                    inc:=inc+1;
                end;
                arrLength:=arrLength-1;
                
                writeln('Data Deleted!');
            end;
        end;
        readln;
    end;

    procedure SortByArray;
    begin
        ShowData(officer,job);
    end;

    procedure SortByName;
    begin
        flag := whichSort(flag);
        copyData(tempOfficer,tempJob);
        NameSort(tempOfficer,tempJob);
        ShowData(tempOfficer,tempJob);
    end;

    procedure SortByWorkHour;
    begin
        flag := whichSort(flag);
        copyData(tempOfficer,tempJob);
        WorkHourSort(tempOfficer,tempJob);
        ShowData(tempOfficer,tempJob);
    end;

    procedure SearchOfficers;
    begin
        repeat
            clrscr; 
            flag:= whichSearch(flag);

            if (flag = 0) then
                writeln('Please Insert Officer Data!')
            else if(flag = 1) then
                SearchByName(officer,job,inc)
            else if(flag = 2) then
                SearchByLocation(officer,job);
        until (flag >= 0) and (flag <= 2);
        readln;
    end;

    procedure EditOfficers;
    begin
        found := False;
        editData := True;
        SearchOfficers;
        EditOfficerData(officer,job,inc);
        editData := False;
    end;

    procedure DeleteOfficers;
    begin
        found := False;
        deleteData := True;
        SearchOfficers;
        DeleteOfficerData(officer,job,inc);
        deleteData := False;
    end;

    procedure ViewOfficers(officer : arrOfficers);
    var menu : integer;
    begin
        clrscr;

        writeln('==================================================');
        writeln('               VIEW OFFICERS DATA');
        writeln('==================================================');
        writeln;

        // Validation if Null Object
        if (arrLength = 0) then 
        begin
            write ('Officers Data is Empty!');
            readln;
        end;

        //View Data Sort
        if(arrLength >= 1) then
            begin
            writeln('Which Sort Data Would You Want to See? ');
            writeln('1. Normal Sort ');
            writeln('2. SortBy Name  ');      //Selection
            writeln('3. SortBy Work Hours '); //Insertion
            writeln;

            write('Answers : ');
            readln(menu);

            writeln('---------------------------------');
            case menu of
                1 : SortByArray; 
                2 : SortByName;
                3 : SortByWorkHour;
            end;
            readln;
        end;
    end;

    procedure InsertOfficers(var officer : arrOfficers; var job : arrJobs);
    var stop : char;
    begin
        clrscr;
        stop := 'Y';

        writeln('==================================================');
        writeln('          INSERT OFFICERS DATA');
        writeln('==================================================');

        while (upcase(stop) = 'Y') do
        begin
            arrLength:=arrLength+1;
            InsertDataList(arrLength);

            //Validation
            writeln('---------------------------------');
            write('Insert Another Officers(Y/N)? ');
            readln(stop);
        end;
    end;

    procedure closeProgram;
    begin
        terminate := True;
    end;

    procedure selectMenu;
    var menu : integer;
    begin
        clrscr;

        writeln('==================================================');
        writeln('           SELAMAT DATANG DI THALLZOO             ');
        writeln('   Aplikasi Pengolah Data Pegawai Kebun Binatang  ');
        writeln('==================================================');
        writeln('   1. Lihat Data Pegawai');  //Lihat berdasarkan: Ascending - Descending (Menu Tampilkan Detail Datanya)
        writeln('   2. Tambah Data Pegawai');
        writeln('   3. Cari Data Pegawai');   //Cari berdasarkan: Nama - Lokasi Kerja (Tampilkan Detail Datanya)
        writeln('   4. Edit Data Pegawai');   //Edit berdasatkan : Nama
        writeln('   5. Hapus Data Pegawai');  //Hapus berdasarkan : Nama
        writeln('   6. Keluar');              //Hapus berdasarkan : Nama
        writeln('--------------------------------------------------');

        repeat
            write('Masukan Pilihan : ');
            readln(menu);
            case menu of
                1: ViewOfficers(officer);
                2: InsertOfficers(officer,job);
                3: SearchOfficers;
                4: EditOfficers;
                5: DeleteOfficers;
                6: closeProgram;
            end;
        until (menu >= 1) and (menu <= 6);
    end;

begin
    clrscr;
    arrLength:=0;
    terminate := False;
    editData := False;
    deleteData := False;

    while (not terminate) do
    begin 
        selectMenu;
    end;

    clrscr;
    writeln('Program Dihentikan');
    readln;
end.