<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>地圖截圖Sample</title>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="https://js.arcgis.com/3.25/"></script>
    <link href="https://js.arcgis.com/3.25/esri/css/esri.css" rel="stylesheet" />
    <script src="Scripts/html2canvas_Fix.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="map">
        </div>
        <input type="button" class="btn btn-primary" value="圖片" onclick="getPic()" />
        <img id="imgA" src="#" alt="Alternate Text" />
        <script>
            window.addEventListener('load', getLocation());
            var currentLoc = []
            function getLocation() {
                if (navigator.geolocation) {
                    const loc = navigator.geolocation.getCurrentPosition(showLocation);
                } else {
                    console.log('不爽秀位置，當然不會顯示');
                }
            }
            function showLocation(position) {
                currentLoc = [position.coords.longitude, position.coords.latitude];
            }

            function getPic() {
                html2canvas(document.querySelector('#map'), {
                    onrendered: function (canvas) {
                        var dataform = canvas.toDataURL();
                        var Base64Data = dataform.split(',')[1];
                        const imgSrc = `data:image/png;base64,${Base64Data}`;
                        document.getElementById('imgA').src = imgSrc;
                    }, useCORS: true
                });
            }
            
            require([
                "esri/map",
                "esri/symbols/SimpleMarkerSymbol",
                "esri/SpatialReference",
                "esri/geometry/Point",
                "esri/Color",
                "esri/graphic",
                "dojo/domReady!"
            ], function (Map, SimpleMarkerSymbol, SpatialReference, Point, Color, Graphic) {

                var map = new Map("map", {
                    center: [0, 0],
                    zoom: 8,
                    basemap: "topo"
                });

                map.on("load", function () {
                    if (currentLoc.length > 0) {
                        var _x = currentLoc[0];
                        var _y = currentLoc[1];
                        point = new Point(_x, _y, new SpatialReference({ wkid: 4326 }));
                        var marker = new SimpleMarkerSymbol();
                        marker.setColor(new Color([255, 0, 0, 1]));
                        marker.setPath("M16,3.5c-4.142,0-7.5,3.358-7.5,7.5c0,4.143,7.5,18.121,7.5,18.121S23.5,15.143,23.5,11C23.5,6.858,20.143,3.5,16,3.5z M16,14.584c-1.979,0-3.584-1.604-3.584-3.584S14.021,7.416,16,7.416S19.584,9.021,19.584,11S17.979,14.584,16,14.584z");
                        marker.setStyle(SimpleMarkerSymbol.STYLE_PATH);
                        marker.setSize(25);

                        var gra = new Graphic(point, marker);
                        map.graphics.add(gra);
                        map.centerAt([_x, _y]);
                    }
                });
            });



        </script>

    </form>
</body>
</html>
