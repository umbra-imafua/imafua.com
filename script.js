function clamp(num, min, max) {
   return num <= min ? min : num >= max ? max : num
}

var mapname = "STARTER"
var mapwidth = 2048;
var mapheight = 2048;
var mapexits = ["TEMPLE", "STARTERCUBBY", null, null];
var mapart = [["biter.png",22,35,42],["hitcharideandhideinside.jpg",30,55,42]];
var maptiles = ["000..........000", "00.............0", "00..............", "00.........00...", "00..........0..0", "000.........0000", "0000.........000", "0000..........00", "000...........00", "00............00", "00............00", "00............00", "00............00", "000..........000", "00000......00000", "0000000..0000000"];

var x = 1024;
var y = 2000;
var xspeed = 8;
var yspeed = 8;
var maxspeed = 8;
var accspeed = 3;
var inputs = [];

var debug = document.querySelector(".debug");
var player = document.querySelector(".player");
var map = document.querySelector("main");
var foremap = document.querySelector("section");
var canvas = document.querySelector("article");

window.addEventListener('load', function () {
   debug = document.querySelector(".debug");
   player = document.querySelector(".player");
   map = document.querySelector("main");
   foremap = document.querySelector("section");
   canvas = document.querySelector("article");
   if (window.location.hash) {
      console.log("hash found: " + document.location.hash);
      loadmap(document.location.hash.toUpperCase().slice(1), -1);
   }else{
      console.log("no hash: " + document.location.hash);
      loadmap("STARTER", -2);
   }
   step();
})

function loadmap(name, exit) {

   console.log("loading: " + name);

   for (m of maps) {

      if (m[0] == name) {

         mapname = m[0];
         mapwidth = m[1];
         mapheight = m[2];
         mapexits = m[3];
         mapart = m[4];
         maptiles = m[5];

         map.style.width = (100 * (mapwidth / 1024)) + 'vmin';
         map.style.height = (100 * (mapheight / 1024)) + 'vmin';
         map.style.backgroundImage = 'url("MAP/export/' + mapname + '-B.png")';
         foremap.style.backgroundImage = 'url("MAP/export/' + mapname + '-F.png")';

         var capacity = Math.floor(maptiles.length*maptiles[0].length*0.03);
         for (let maY = 0; maY < maptiles.length; maY++){
            for (let maX = 0; maX < maptiles[0].length; maX++){
               if (maptiles[maY][maX] == "0") {
                  
                  if(Math.floor(Math.random() * capacity)==0){
                     
                     if (maY > 0) { if (maptiles[maY-1][maX] == "." ) { continue; }}
                     if (maX > 0) { if (maptiles[maY][maX-1] == "." ) { continue; }}
                     if (maY < maptiles.length -1 ) { if (maptiles[maY+1][maX] == "." ) { continue; }}
                     if (maX < maptiles[0].length -1 ) { if (maptiles[maY][maX+1] == "." ) { continue; }}
                     
                     if(mapart.length<capacity){
                        var matype = Math.floor(Math.random() * 10)

                        if(matype<3){
                           var thisart = images[Math.floor(Math.random()*images.length)];
                           mapart.push([thisart,maX*6,maY*6,16]);
                        }else if(matype==4){
                           var thisart = videos[Math.floor(Math.random()*videos.length)];
                           mapart.push([thisart,maX*6,maY*6,16]);
                        }
                     }
                  }
               }
            }
         }

         canvas.innerHTML = "";
         for (ma of mapart){
            if(ma[0].includes(".")){
               var extention = ma[0].split('.').pop();
               switch(extention) {
                  case "jpg":
                  case "jpeg":
                  case "png":
                     canvas.innerHTML = canvas.innerHTML + '<img src=" COMPRESSED/' +  ma[0] + '" alt="" style="top: ' + ma[2] + 'vmin; left: ' + ma[1] + 'vmin; width: ' + ma[3] + 'vmin; z-index: 25;">';
                     break;
                  case "webm":
                     canvas.innerHTML = canvas.innerHTML + '<video autoplay loop muted playsinline style="top: ' + ma[2] + 'vmin; left: ' + ma[1] + 'vmin; width: ' + ma[3] + 'vmin; z-index: 55;"><source src=" COMPRESSED/' + ma[0] + '" type="video/webm"></video>';
                     break;
                  default:
                  // code block
               }
            }
         }

         var initentrychecker = null;
         if (exit == -10) {
            y = 2000;
            x = 1024;
         } else if (exit == -1) {
            y = mapheight / 2;
            x = mapwidth / 2;
         } else if (exit == 0) {
            y = mapheight - 32;
            for (let entrychecker in maptiles[maptiles.length - 1]) {
               if (maptiles[maptiles.length - 1][entrychecker] == ".") {
                  if (initentrychecker == null) {
                     initentrychecker = (entrychecker * 64) + 32
                  } else {
                     x = (initentrychecker + ((entrychecker * 64) + 32)) / 2;
                  }
               }
            }
         } else if (exit == 1) {
            x = 32;
            for (let entrychecker in maptiles) {
               if (maptiles[entrychecker][0] == ".") {
                  if (initentrychecker == null) {
                     initentrychecker = (entrychecker * 64) + 32
                  } else {
                     y = (initentrychecker + ((entrychecker * 64) + 32)) / 2;
                  }
               }
            }
         } else if (exit == 2) {
            y = 32;
            for (let entrychecker in maptiles[0]) {
               if (maptiles[0][entrychecker] == ".") {
                  if (initentrychecker == null) {
                     initentrychecker = (entrychecker * 64) + 32
                  } else {
                     x = (initentrychecker + ((entrychecker * 64) + 32)) / 2;
                  }
               }
            }
         } else if (exit == 3) {
            x = mapwidth - 32;
            for (let entrychecker in maptiles) {
               if (maptiles[entrychecker][maptiles[entrychecker].length-1] == ".") {
                  if (initentrychecker == null) {
                     initentrychecker = (entrychecker * 64) + 32
                  } else {
                     y = (initentrychecker + ((entrychecker * 64) + 32)) / 2;
                  }
               }
            }
         }

         document.location.hash = name.toLowerCase();
         break;
      }
   }
}

const locationstep = () => {

   xspeed -= Math.sign(xspeed);
   yspeed -= Math.sign(yspeed);

   const vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0)
   const vh = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0)

   const input = inputs[0];

   if (input) {
      if (inputs.includes(directions.down)) { yspeed += accspeed;
         player.setAttribute("facing", "v");
      }
      if (inputs.includes(directions.up)) { yspeed -= accspeed;
         player.setAttribute("facing", "^");
      }
      if (inputs.includes(directions.right)) { xspeed += accspeed;
         player.setAttribute("facing", ">"); 
         if (inputs.includes(directions.up)) { player.setAttribute("facing", ">^");} 
         if (inputs.includes(directions.down)) { player.setAttribute("facing", ">v");}
      }
      if (inputs.includes(directions.left)) { xspeed -= accspeed;
         player.setAttribute("facing", "<"); 
         if (inputs.includes(directions.up)) { player.setAttribute("facing", "<^");} 
         if (inputs.includes(directions.down)) { player.setAttribute("facing", "<v");}
      }      

   }

   xspeed = clamp(xspeed, -maxspeed, maxspeed);
   yspeed = clamp(yspeed, -maxspeed, maxspeed);

   for (let walkstep = 0; walkstep < Math.abs(xspeed) + Math.abs(yspeed); walkstep++) {

      var oldx = x;
      var oldy = y;

      if (walkstep < Math.abs(xspeed)) {
         if (xspeed > 0) {
            x += 1;
         }
         if (xspeed < 0) {
            x -= 1;
         }
      } else {
         if (yspeed > 0) {
            y += 1;
         }
         if (yspeed < 0) {
            y -= 1;
         }
      }

      var xt = clamp(Math.floor(x / 128), 0, maptiles.length - 1);
      var yt = clamp(Math.floor(y / 64), 0, maptiles.length - 1);

      if ((xt + yt) % 2 == 0) { // break this way > \
         xt *= 2;
         if ((x % 128) - ((y % 64) * 2) > 0) {
            xt += 1;
         }
      } else { // break this way > /
         xt *= 2;
         if ((x % 128) + ((y % 64) * 2) > 128) {
            xt += 1;
         }
      }
      var tilerow = maptiles[yt]
      if (tilerow[xt] == "0") {
         x = oldx; y = oldy;
      }

      if (x < 0) {
         if (mapexits[3] != null) {
            loadmap(mapexits[3], 3);
         } else { x = 0; }
      }
      if (x > mapwidth - 1) {
         if (mapexits[1] != null) {
            loadmap(mapexits[1], 1);
         } else { x = mapwidth - 1; }
      }
      if (y < 0) {
         if (mapexits[0] != null) {
            loadmap(mapexits[0], 0);
         } else { y = 0; }
      }
      if (y > mapheight - 1) {
         if (mapexits[2] != null) {
            loadmap(mapexits[2], 2);
         } else { y = mapheight - 1; }
      }
   }
   player.setAttribute("walking", input ? "true" : "false");

   var mapx = clamp((-x / 10.24) + 50, -(mapwidth - 1024) / 10.24, 0);
   var mapy = clamp((-y / 10.24) + 50, -(mapheight - 1024) / 10.24, 0);

   map.style.transform = `translate3d( ${mapx}vmin, ${mapy}vmin, 0 )`;
   player.style.transform = `translate3d( ${(x / 10.24)}vmin, ${(y / 10.24)}vmin, 0 )`;

}

const step = () => {

   debug.innerHTML = "";

   locationstep();

   window.requestAnimationFrame(() => {
      step();
   })
}

const directions = { up: "up", down: "down", left: "left", right: "right",}
const keys = { 38: directions.up, 37: directions.left, 39: directions.right, 40: directions.down,}
document.addEventListener("keydown", (e) => {
   var dir = keys[e.which];
   if (dir && inputs.indexOf(dir) === -1) {
      inputs.unshift(dir)
   }
})
document.addEventListener("keyup", (e) => {
   var dir = keys[e.which];
   var index = inputs.indexOf(dir);
   if (index > -1) {
      inputs.splice(index, 1)
   }
});
