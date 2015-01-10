<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SampleMap.aspx.cs" Inherits="SampleMap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        /*html, body, #map-canvas {
            height: 100%;
            margin: 0;
            padding: 0;
        }*/
    </style>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <%--<script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBRH_xGsnLzgygoReXEEgOrFGETYu569Es&signed_in=true">
    </script>--%>
    <script type="text/javascript">
        var currentCenter;
        var cityCircle;
        var map;
        var infoWindow;
        var markers = [];

        function initialize() {
            var mapOptions = {
                center: { lat: 40.70302526, lng: -74.0032196 },
                zoom: 10
            };
            
            map = new google.maps.Map(document.getElementById('map-canvas'),
                mapOptions);
            cityCircle;
            var populationOptions = {
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: '#FF0000',
                fillOpacity: 0.35,
                draggable: true,
                map: map,
                center: { lat: 40.70845824, lng: -74.00884151 },
                radius: Math.sqrt(100000) * 100,
                editable: true
            };

            cityCircle = new google.maps.Circle(populationOptions);
            cityCircle.setMap(map);

            infoWindow = new google.maps.InfoWindow();
            google.maps.event.addListener(cityCircle, 'bounds_changed', showNewRect);

        }

        function showNewRect(event) {
            //            alert(cityCircle);
            //if (currentCenter == null)
            //    currentCenter = cityCircle.center;
            //var newCurrentCenter = cityCircle.center;
            //if (newCurrentCenter.lat != currentCenter.lat) {
            //    if (newCurrentCenter.lng != currentCenter.lng)
            //    //If old and current position different then do something
            //    alert('hi');
            //}
            //infoWindow.setContent('hiiiii');
            //infoWindow.setPosition(cityCircle.center);

            //infoWindow.open(map);
            var URL = "http://localhost:51278/JSONdata.aspx?Option=GetMapLocations&Radius=" + cityCircle.radius +  "&lat=" + cityCircle.getCenter().D + "&Lon=" + cityCircle.getCenter().k;
            $.getJSON(URL, function (data) {
           // $.getJSON("http://localhost:51278/JSONdata.aspx?Option=GetMapLocations", function (data) {

                //alert(data);
                console.log(data);
                // Success !
                // We managed to load the JSON, now, let's iterate through the "Customers" records, and add a
                // drop down list item for each.
                $.each((data), function () {
                    //$("#listOfCustomers").append($("<option />").val(this.CustomerID).text(this.CompanyName));
                    //                    alert(this.header

                    var loc = new google.maps.LatLng(this.lon, this.lat);//cityCircle.getCenter();//new google.maps.LatLng(cityCircle.center.lat, cityCircle.center.lng);
                    if (pointInCircle(loc, cityCircle.getRadius(), cityCircle.getCenter()))
                        addMarker(loc, this.detailSummary, this.key);

                });
            });

            setAllMap(null);
                //icon: image
        }

        function setAllMap(map) {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(map);
            }
        }

        var infowindowMarker = new google.maps.InfoWindow({
            content: 'contentString'
        });

        function addMarker(location, content, key) {


            var marker = new google.maps.Marker({
                position: location,
                map: map
            });
            google.maps.event.addListener(marker, 'click', function () {

                $.ajax({
                    type: "POST",
                    url: "JsonData.aspx/GetContentByKey",
                    data: '{key: "' + key + '" }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {

                        infowindowMarker.setContent(response.d);
                        infowindowMarker.open(map, marker);
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });

                //$.ajax("http://localhost:51278/JSONdata.aspx?Option=GetMapLocations&Key=" + key, {
                //    success: function (data) {
                //        content = $(data).D;
                //     },
                //    error: function () {
                //        $('#notification-bar').text('An error occurred');
                //    }
                //});

                
            });



            //var marker = new google.maps.Marker({
            //    position: location,
            //    map: map
            //});
            markers.push(marker);
        }

        function pointInCircle(point, radius, center) {
            return (google.maps.geometry.spherical.computeDistanceBetween(point, center) <= radius)
        }

        //function arePointsNear(checkPoint, centerPoint, km) {
        //    var ky = 40000 / 360;
        //    var kx = Math.cos(Math.PI * centerPoint.lat / 180.0) * ky;
        //    var dx = Math.abs(centerPoint.lng - checkPoint.lng) * kx;
        //    var dy = Math.abs(centerPoint.lat - checkPoint.lat) * ky;
        //    return Math.sqrt(dx * dx + dy * dy) <= km;
        //}


        google.maps.event.addDomListener(window, 'load', initialize);
    </script>

<%--     <script type = "text/javascript">
         function ShowCurrentTime(key) {
             $.ajax({
                 type: "POST",
                 url: "JsonData.aspx/GetContentByKey",
                 data: '{key: "' + key + '" }',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: OnSuccess,
        failure: function (response) {
            alert(response.d);
        }
    });
}
function OnSuccess(response) {
    alert(response.d);
}
</script>--%>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="map-canvas" style="width: 804px; top: 68px; left: 172px; position: absolute; height: 638px; background-color: rgb(229, 227, 223); overflow: hidden;"></div>

        </div>
    </form>
</body>
</html>
