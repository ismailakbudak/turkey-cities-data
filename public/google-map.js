(function(){

  $.getJSON( "/cities.json", function( data ) {
    
    var markers = [];

    $.each( data, function( key, city ) {
      console.log(city.name);
      markers.push([city.lattitude, city.longitude, city.name])
    });

    // Example cities data
    // markers = [
    //   [37.09024, -95.712891, 'trialhead0'],
    //   [-14.235004, -51.92528, 'trialhead1'],
    //   [-38.416097, -63.616672, 'trialhead2']
    // ];

    drawMap(markers);

  });

  function drawMap(markers){
    var map;
    var global_markers = [];

    var infowindow = new google.maps.InfoWindow({});

    function initialize() {
      geocoder = new google.maps.Geocoder();
      var latlng = new google.maps.LatLng(39, 35);
      var myOptions = {
        zoom: 6,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
      map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
      addMarker();
    }

    function addMarker() {
      for (var i = 0; i < markers.length; i++) {
        // obtain the attribues of each marker
        var lat = parseFloat(markers[i][0]);
        var lng = parseFloat(markers[i][1]);
        var trailhead_name = markers[i][2];

        var myLatlng = new google.maps.LatLng(lat, lng);

        var contentString = "<html><body><div><p><h2>" + trailhead_name + "</h2></p></div></body></html>";

        var marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          title: "Coordinates: " + lat + " , " + lng + " | Trailhead name: " + trailhead_name
        });

        marker['infowindow'] = contentString;

        global_markers[i] = marker;

        google.maps.event.addListener(global_markers[i], 'click', function() {
          infowindow.setContent(this['infowindow']);
          infowindow.open(map, this);
        });
      }
    }

    window.onload = initialize;
  }

})();
