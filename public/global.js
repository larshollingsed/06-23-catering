/**
 * Created by Patrick Carlton & Larz Hollingsed on 7/9/15.
 */




function toggle_nav() {
    var nav = document.getElementById("menu_nav")

    if (nav.className == "hide_dis_nav") {
        nav.className = "";

    } else {
        nav.className = "hide_dis_nav";
    }
}

document.getElementById("hamburger").onclick = toggle_nav;