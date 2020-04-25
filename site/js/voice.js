function check(x) {
    elements = document.getElementsByClassName(x);
    
    if (x == "timid") {
        for (var i = 0; i < elements.length; i++) {
            elements[i].style.color = "#6F57FF";
            elements[i].style.fontWeight = "bold";
        }
    }
    if (x == "confident") {
        for (var i = 0; i < elements.length; i++) {
            elements[i].style.color = "#E25822";
            elements[i].style.fontWeight = "bold";
        }
    }
    if (x == "mocking") {
        for (var i = 0; i < elements.length; i++) {
            elements[i].style.color = "#BA55D3";
            elements[i].style.fontWeight = "bold";
        }
    }
}