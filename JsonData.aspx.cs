using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public class MapData
{
    public string header;
    public string detailSummary;
    public double lon;
    public double lat;
    public long key;
}

public partial class JsonData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Request.QueryString["Option"] == "GetMapLocations")
        {
            Response.Clear();
            Response.Write(GetMapLocations(Convert.ToDouble(this.Request.QueryString["Radius"]),
                Convert.ToDouble(this.Request.QueryString["lat"]),
                Convert.ToDouble(this.Request.QueryString["lon"])));
            Response.End();
        }
        //else if (this.Request.QueryString["Option"] == "GetContentByKey")
        //{
        //    Response.Clear();
        //    Response.Write(GetContentByKey(Convert.ToInt64(this.Request.QueryString["Key"])));
        //    Response.End();
        //}
    }

    [System.Web.Services.WebMethod]
    public static string GetContentByKey(long key)
    {
        string contentString = @"<div id=content><div id=siteNotice></div><h1 id=firstHeading class=firstHeading>" + key.ToString() + @"Uluru</h1><div id=bodyContent><p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large 
sandstone rock formation in the southern part of the </p>" +"<p>Attribution: Uluru, <a href=\"https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194\"></p></div></div>";
        return contentString;
    }


    public string GetMapLocations(double radius, double centerlat, double centerlon)
    {
        string mapJson = string.Empty;

        List<MapData> mapDatas = new List<MapData>();
        MapData md = new MapData();
        md.header = "header1";
        md.detailSummary = "header1";
        md.lon = 40.7117113;
        md.lat = -73.99819851;
        md.key = 1;
        if (IsInCircle(centerlat, centerlon, md.lat, md.lon, radius))
            mapDatas.Add(md);

        md = new MapData(); md.header = "header11";
        md.detailSummary = "header11";
        md.lon = 40.72042874;
        md.lat = -73.98317814;
        md.key = 2; if (IsInCircle(centerlat, centerlon, md.lat, md.lon, radius))
            mapDatas.Add(md);

        md = new MapData();
        md.header = "header111";
        md.detailSummary = "header111";
        md.lon = 40.73194181;
        md.lat = -74.00841236;
        md.key = 3;
        if (IsInCircle(centerlat, centerlon, md.lat, md.lon, radius))
            mapDatas.Add(md);
        md = new MapData();
        md.header = "header1111";
        md.detailSummary = "header1111";
        md.lon = 40.75730257;
        md.lat = -73.98472309;
        if (IsInCircle(centerlat, centerlon, md.lat, md.lon, radius))
            mapDatas.Add(md);


        md = new MapData();
        md.header = "header1111";
        md.detailSummary = "header1111";
        md.lon = 38.92309227;
        md.lat = -74.92950439;
        md.key = 4; if (IsInCircle(centerlat, centerlon, md.lat, md.lon, radius))
            mapDatas.Add(md);

        return JsonConvert.SerializeObject(mapDatas);
    }

    public bool IsInCircle(double Latitude, double Longitude, double centerLatitude, double centerLongitude, double radius)
    {
        if (GetDistanceTo(Latitude, Longitude, centerLatitude, centerLongitude) <= radius)
            return true;
        return false;
    }

    public double GetDistanceTo(double Latitude, double Longitude, double centerLatitude, double centerLongitude)
    {
        {
            double latitude = Latitude * 0.0174532925199433;
            double longitude = Longitude * 0.0174532925199433;
            double num = centerLatitude * 0.0174532925199433;
            double longitude1 = centerLongitude * 0.0174532925199433;
            double num1 = longitude1 - longitude;
            double num2 = num - latitude;
            double num3 = Math.Pow(Math.Sin(num2 / 2), 2) + Math.Cos(latitude) * Math.Cos(num) * Math.Pow(Math.Sin(num1 / 2), 2);
            double num4 = 2 * Math.Atan2(Math.Sqrt(num3), Math.Sqrt(1 - num3));
            double num5 = 6376500 * num4;
            return num5;
        }
    }
}