/* 

var artlist = []; //the array we will store the files
var memelist = []; //the array we will store the files

//loads a files file into the array "files"
function get_filelists(file_source_list){
  for(let i = 0; i < file_source_list.length; i++){
    var file_raw = new XMLHttpRequest();

    var file_source = ("/media/" + file_source_list[i] + ".txt")
    
    file_raw.open("GET", file_source, false); //start loading the file
    file_raw.onreadystatechange = function (){
      if(file_raw.readyState === 4){
        if(file_raw.status === 200 || file_raw.status == 0){ //done loading
            var file_txt = file_raw.responseText;
            artlist = file_txt.split('\n'); //split the lines of that string into an array
            //alert("Returning "+ file_source + "  status: " + file_raw.readyState + " | " + window[file_source_list[i]]); //debug the loading proccess
        }
      }
    }
    file_raw.send(null);
  }
}

get_filelists(["artlist","memelist"])
alert(artlist)

var sectionone = document.querySelector('#sectionone'); 

for(let i = 0; i < artlist.length; i++){
  let element = document.createElement("article");
  element.innerHTML = "<img src=\"/media/" + artlist[i] + "\">"
}

*/