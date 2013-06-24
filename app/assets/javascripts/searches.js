var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var map;
var geocoder;
var route_pts = [];


function initialize() {
  geocoder = new google.maps.Geocoder();
  directionsDisplay = new google.maps.DirectionsRenderer();
  var chicago = new google.maps.LatLng(41.850033, -87.6500523);

  var mapOptions = {
    zoom: 6,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: chicago
  };

  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  directionsDisplay.setMap(map);
  calcRoute();
  codeAddress();
  directionsDisplay.setPanel(document.getElementById('directions_panel'));

  var control = document.getElementById('control');
  // control.style.display = 'block';
  // maps.controls[google.maps.ControlPosition.TOP_CENTER].push(control);

} // initialize

function calcRoute() {
  var start = document.getElementById('start').value;
  var end = document.getElementById('end').value;
  var waypts = [];

  var waypoints_hidden_inputs = $('.waypoints');
  for (var i = 0; i < waypoints_hidden_inputs.length; i++) {
    waypts.push({
      location:waypoints_hidden_inputs[i].value,
      stopover:false
    });
  }
  var request = { // keep as 'request'
      origin: start,
      destination: end,
      waypoints: waypts,
      optimizeWaypoints: true,
      travelMode: google.maps.TravelMode.DRIVING
  };

  // var dists=[trip_length]; // atl.  trip_length determines how frequently we drop markers along route.
  // var trip_length =
  //   if trip_distance <= 7, then trip_length == 1
  //     if trip_distance > 7 && trip_distance <= 50, then trip_length == 5
  //       if trip_distance > 50, then trip_length == 10;

  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
      var route = response.routes[0];


      var points = route.overview_path;
      // console.log(points);
      // console.log(points.length);

      for(var i = 0; i < points.length; i+=20 ) {
        // here on looping through the array of points along the route, returning every 10th point and returning the latitude and longitude:
        var latitude = points[i].jb;
        // console.log(points[i].jb);

        var longitude = points[i].kb;
        // console.log(points[i].kb);
        // console.log(typeof(points[i]));
        // ** put these into an array ****
        route_pts.push([latitude, longitude]);
        //console.log(route_pts);
      }



      var summaryPanel = document.getElementById('directions_panel');
      summaryPanel.innerHTML = '';
      // For each route, display summary information.
      for (var i = 0; i < route.legs.length; i++) {
        var routeSegment = i + 1;
        summaryPanel.innerHTML += '<b>Route Segment: ' + routeSegment + '</b><br>';
        summaryPanel.innerHTML += route.legs[i].start_address + ' to ';
        summaryPanel.innerHTML += route.legs[i].end_address + '<br>';
        summaryPanel.innerHTML += route.legs[i].distance.text + '<br><br>';
      }
    }
  });
  console.log(map);
} // calcRoute

function codeAddress() {
  var yelp_address = [];

  var address= $('.address');

  address.each(function(el){
    yelp_address.push({location: this.value});
  });

  for (var i = 0; i < yelp_address.length; i++) {
    geocoder.geocode( { 'address': yelp_address[i].location}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        var marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        });
      }
       else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
  }
} // codeAddress




$(document).ready(function() {
google.maps.event.addDomListener(window, 'load', initialize);


});