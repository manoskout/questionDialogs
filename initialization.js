  document.addEventListener('DOMContentLoaded', function() {
    var elem = document.querySelector('.collapsible');
    var instanceEDIT = M.Collapsible.init(elem, {
      accordion: true
    });
    var elem = document.querySelector('.collapsible.expandable');
    var instanceKB = M.Collapsible.init(elem, {
      accordion: false
    });
    
  });

  function showDiv(toggle){
    document.getElementById(redBadge).style.display = 'block';
    }

  document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.modal');
    var instances = M.Modal.init(elems, {
      opacity: 0.5
    });
  });
