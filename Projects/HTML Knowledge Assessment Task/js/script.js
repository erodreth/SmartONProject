// Select the 'header' element using its tag name and assign it to the variable 'header'
const header = document.querySelector("header");

// Add a scroll event listener to the window
window.addEventListener("scroll", function() {
    // Toggle the 'sticky' class on the 'header' element based on the scroll position
    header.classList.toggle("sticky", window.scrollY > 0);
});

// Select the elements with the IDs 'menu-icon' and 'navbar' and assign them to the variables 'menu' and 'navbar', respectively
let menu = document.querySelector('#menu-icon');
let navbar = document.querySelector('.navbar');

// Add a click event listener to the 'menu' element (likely an icon)
menu.onclick = () => {
    // Toggle the 'bx-x' class on the 'menu' element
    menu.classList.toggle('bx-x');
    // Toggle the 'open' class on the 'navbar' element
    navbar.classList.toggle('open');
};

// Add a scroll event to the window
window.onscroll = () => {
    // Remove the 'bx-x' class from the 'menu' element
    menu.classList.remove('bx-x');
    // Remove the 'open' class from the 'navbar' element
    navbar.classList.remove('open');
};