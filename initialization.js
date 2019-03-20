  document.addEventListener('DOMContentLoaded', function() {
    var elem = document.querySelector('.collapsible');
    var instance = M.Collapsible.init(elem, {
      accordion: false
    });
    
  });

  document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.modal');
    var instances = M.Modal.init(elems, {
      opacity: 0.5
    });
  });
