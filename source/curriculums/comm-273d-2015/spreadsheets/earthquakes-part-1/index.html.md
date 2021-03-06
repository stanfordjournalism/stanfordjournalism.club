---
title: How (and why) to use a spreadsheet to turn a beautiful interactive earthquake map of into a bar chart
description: |
  A walkthrough of basic spreadsheet and pivot table usage
    (Part 1 of 3)
nutgraf: |
    We have a lot of ways to easily create beautiful, elaborate visualizations. But let's see what we can do when we prioritize the story of the data over its visual presentation.
---


What does it mean to find and tell stories with data?


The core challenge of telling stories with data is to turn an unreadable dump of text -- i.e. data -- into something _readable_. In this lesson, we learn how to turn that text into a beautiful interactive map, such as this [CartoDB torque map](http://docs.cartodb.com/tutorials/introduction_torque.html):

<iframe width="100%" height="580" frameborder="0" src="https://dundee.cartodb.com/viz/888634d0-60ae-11e5-93c9-0e018d66dc29/embed_map" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>


It took me literally 5 minutes to make this map. That includes remembering about the [CartoDB service](https://cartodb.com/), then creating an account, confirming my account, uploading the data, and using the map wizard. [I didn't even have to read their great tutorials](http://docs.cartodb.com/tutorials.html).

But even before thinking about what we can _do_ with the data, I want this lesson to show that we should first think about _what we can find in the data_. In other words, __what are the important stories we can find in data? And how do we find those stories?__ 





Here are the important data links before you dive into the wall of text that is this lesson.

- __The CSV of 2011 to 2015 earthquakes as collected from the United States Geological Survey:__ [usgs-us-with-fips-quakes.csv](/files/data/usgs-us-with-fips-quakes.csv). It contains more than 5,500 records for all earthquakes within the boundaries of the United States that were of _magnitude 3.0 or more_.
- __The CartoDB torque map made from the USGS data:__ [The public view of the map](https://dundee.cartodb.com/viz/888634d0-60ae-11e5-93c9-0e018d66dc29/public_map), which also links to a data table that contains the data from the aforementioned CSV. 
- __All the answers to this tutorial, as a Google spreadsheet__: The spreadsheets, pivot tables, and charts created in this [3-part-tutorial are available in this massive Google Sheet](https://docs.google.com/spreadsheets/d/16LKYJN-JjpbSP5m5pvVttkG-XNJL7_QabSHnhvMpByk/edit#gid=1127221441).

<% end %>

However, there's not much fun in just copying my work. So just __start from the original CSV__: [usgs-us-with-fips-quakes.csv](/files/data/usgs-us-with-fips-quakes.csv).

If you want to jump straight to the spreadsheeting, that starts in [Part 2](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2). Otherwise, read on for some quick thoughts about maps and more details about the United States Geological Survey's earthquake data.

--------

<%= render_toc %>


# What's in the USGS data?

<% content_card "Too much information...?" do %>

Reading this section is _not necessary_ for doing this exercise. I provide it as context. The most important part is understanding [how I've modified the data to include United States specific information](#mark-about-this-location-data), which will become important when we learn about spatial data joins via QGIS ([here's a great tutorial by Michael Corey to tide you over](http://mikejcorey.github.io/qgis_advanced_2015/)).

Otherwise, feel free to skip to the section [Why Make a Map?](#mark-why-make-a-map) 

<% end %>

The United States Geological Survey (USGS) offers [downloadable historical earthquake data via its Earthquake Hazards archive](http://earthquake.usgs.gov/earthquakes/search/) and [real-time feeds](http://earthquake.usgs.gov/earthquakes/feed/v1.0/).

For this exercise, we will be using __comma-delimited data__ (CSV format) from the [archive](http://earthquake.usgs.gov/earthquakes/search/), but you can get a snapshot of what it looks like by visiting the [USGS landing page for its real-time CSV data](http://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php). On that page is a list of the fields, of which these are the most relevant to us:

- [`time`](http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php#time): the time of an earthquake event, in [Coordinated Universal Time](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and formatted as [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601): `2015-10-04T05:04:09Z` 
- `latitude` and `longitude`: the coordinates for the earthquake event.
- `place`: a vague but human-readable description of the earthquake's location, e.g. `"Southern Alaska"` and `"36km WNW of La Belleza, Colombia"`
- [`mag`](http://earthquake.usgs.gov/earthquakes/feed/v1.0/glossary.php#mag): a decimal number, typically in the range of -1 to 10, representing the [relative size of an earthquake](http://earthquake.usgs.gov/learn/glossary/?term=magnitude). This actually isn't terribly important for this exercise but is a number that is common to think about when it comes to earthquakes.

## Getting the USGS data for yourself

<% content_card "Quick reminder: Here's my data" do %>
The data for this exercise is here: [usgs-us-with-fips-quakes.csv](/files/data/usgs-us-with-fips-quakes.csv). But I have _modified_ and augmented it in very important ways, [which I detail later](#mark-about-this-location-data).
<% end %>

The [USGS earthquake archive provides a web form](http://earthquake.usgs.gov/earthquakes/search/) for data access:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-form.png){:.bordered}

The most relevant input fields are __Date & Time__, __Magnitude__, and __Output Options__. 

#### Output options

This should be set to CSV. The default option, __Map and list__, will produce, well, [a map and list](http://earthquake.usgs.gov/earthquakes/map/#%7B%22feed%22%3A%221443993922762%22%2C%22search%22%3A%7B%22id%22%3A%221443993922762%22%2C%22name%22%3A%22Search%20Results%22%2C%22isSearch%22%3Atrue%2C%22params%22%3A%7B%22starttime%22%3A%222015-09-26%2000%3A00%3A00%22%2C%22minmagnitude%22%3A4%2C%22endtime%22%3A%222015-10-03%2023%3A59%3A59%22%2C%22orderby%22%3A%22time%22%7D%7D%2C%22listFormat%22%3A%22default%22%2C%22sort%22%3A%22newest%22%2C%22basemap%22%3A%22grayscale%22%2C%22autoUpdate%22%3Afalse%2C%22restrictListToMap%22%3Atrue%2C%22timeZone%22%3A%22utc%22%2C%22mapposition%22%3A%5B%5B-67.06743335108297%2C181.23046875%5D%2C%5B72.86793049861396%2C395.50781249999994%5D%5D%2C%22overlays%22%3A%7B%22plates%22%3Atrue%7D%2C%22viewModes%22%3A%7B%22help%22%3Afalse%2C%22list%22%3Atrue%2C%22map%22%3Atrue%2C%22settings%22%3Afalse%7D%7D):

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-map-and-list.png)

This is nice, but not helpful if we want to do our own data analysis. The other formats, such as __GeoJSON__, are definitely useful, but only if you know enough programming to work with JSON efficiently. The raw GeoJSON looks like this:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-geo-json.png)

The __CSV__ output is not much prettier to human eyes:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-csv-raw.png)

But it's something that can be easily imported into a spreadsheet, which is good enough for us:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-csv-excel.png)

#### Magnitude

I suggest setting the __minimum__ of the __magnitude__ to at least __3__. The number of all earthquakes worldwide, in the last 30 days, can range near 10,000, with 80 to 90 percent having a magnitude less than M3.0. If you want to verify this for yourself, visit the [USGS real-time feeds page](http://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php) and download the "Past 30 Days: All Earthquakes" file (or just click this [link](http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv)).

Is it worth counting earthquakes that have [about as much perceivable force to humans as a car driving by](http://earthquake.usgs.gov/learn/topics/mag_vs_int.php)? Probably not, if you aren't professionally studying geology. For our purposes, including weaker-than-M3.0+ earthquakes involves downloading a much bigger dataset.

The big reason for our purposes is that the USGS archive will return a __maximum of 20,000 records at a time__. Trying to do a very large query, such as [all earthquakes in the last 5 years](http://earthquake.usgs.gov/fdsnws/event/1/query.csv?starttime=2011-01-01%2000:00:00), regardless of magnitude, will result in an error message:

      Error 400: Bad Request

      344492 matching events exceeds search limit of 20000. Modify the search to match fewer events.

      Usage details are available from http://earthquake.usgs.gov/fdsnws/event/1

      Request:
      /fdsnws/event/1/query.csv?starttime=2011-01-01%2000:00:00

      Request Submitted:
      2015-10-04T21:37:49+00:00

      Service version:
      1.0.17

So including weak earthquakes means having to fiddle with the __Limit Results__ input fields and downloading multiple batches, which is a bit of an inconvenience.

#### Date & Time

Even though we can set the start time of our query to the entire last century, earthquake-detection capabilities has changed over time. You can [read the caveats and details about the USGS data here](http://earthquake.usgs.gov/earthquakes/map/doc_aboutdata.php). Keeping in mind the 20,000-record-per-request limit, I think it's best to query within the last 20 years.

The USGS does not have an international seismic sensor array as complete as its United States network. In fact, [its (outdated) statistics page says](http://earthquake.usgs.gov/earthquakes/eqarchives/year/eqstats.php):

> Starting in January 2009, the USGS National Earthquake Information Center no longer locates earthquakes smaller than magnitude 4.5 outside the United States, unless we receive specific information that the earthquake was felt or caused damage.

Although the [USGS archive includes data from international networks](http://earthquake.usgs.gov/earthquakes/map/doc_aboutdata.php), it's safe to assume that the historical number of records for weak earthquakes is a bit nebulous. 

#### Geographic Region

The USGS search form provides a handy interactive tool for specifying a region to request data for:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-archive-map-tool.jpg)

As you can see, my attempt to specify all of the United States, including Alaska, results in a bounding box that will include earthquakes from parts of Canada, Mexico, and Russia.

Why can't we just specify a region by name, such as "the United States"? Because that's not how the USGS categorizes earthquakes. [More on that later](#mark-about-this-location-data).

#### Practice your cURLing

If you don't know anything about [curl](http://curl.haxx.se/) or using the command-line, you can skip this part.

However, if you do know __curl__, and you know a bit about your [browser's network inspection panel](https://developer.chrome.com/devtools/docs/network), you can see how the GET requests behind the USGS form. If you don't feel like fiddling around with buttons and inputs, here's the curl request needed to get data for M3.0+ North American earthquakes since 2011 through September 2015:

~~~sh
usgs_url='http://earthquake.usgs.gov/fdsnws/event/1/query.csv?starttime=2011-01-01%2000:00:00&maxlatitude=72.396&minlatitude=5.616&maxlongitude=-44.297&minlongitude=-197.578&minmagnitude=3&endtime=2015-09-20%2023:59:59&orderby=time&limit=20000&offset='
curl --compressed "${usgs_url}1" -o data/usgs-north-america-quakes.csv
curl --compressed "${usgs_url}20001" | tail -n +2 >> data/usgs-north-america-quakes.csv
~~~

The result of those two GET requests can be found in my stashed copy here: [usgs-north-america-quakes.csv](/files/data/usgs-north-america-quakes.csv)

<a id="mark-about-this-location-data"></a>

## How to get USGS data by U.S. state

In the dataset I provide for this exercise -- [usgs-us-with-fips-quakes.csv](/files/data/usgs-us-with-fips-quakes.csv) -- contains __5,537__ records of M3.0+ earthquakes since 2011 that have occurred within the borders of the United States. I extracted this subset of data from the standard USGS data, in which I drew a bounding box around all of North America. This data -- which you can see here: [usgs-north-america-quakes.csv](/files/data/usgs-north-america-quakes.csv) -- contains __23,347 records__, i.e earthquakes that happened in Canada, or the ocean.

Remember that the USGS data includes only a `place` field, which contains a vague, human-readable description such as `"Southern Alaska"` and `"36km WNW of La Belleza, Colombia"`.

So how did I get filter the data to include only earthquakes within the United States when the USGS doesn't provide a way to filter the data by political boundaries?

By cross-referencing the __latitude__ and __longitude__ data with [U.S. Census boundary data](https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html). So...OK, how did I do _that_? That's a topic for a much later tutorial on QGIS (check out Michael Corey's QGIS tutorial for NICAR: [Manipulating and editing geographic data with QGIS](http://mikejcorey.github.io/qgis_advanced_2015/)).

The upshot is that the [usgs-us-with-fips-quakes.csv](/files/data/usgs-us-with-fips-quakes.csv) file, besides being a filtered subset of data, contains two fields that I've added: __STUSPS__ and __FIPS__:

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-fips-preview-cols.png)

__STUSPS__ stands for _United States Postal Code_ -- e.g. `AK` and `NY` -- and __FIPS__ is the [federal code](https://en.wikipedia.org/wiki/Federal_Information_Processing_Standards) designated for each United States county, e.g. `06075` for [San Francisco county](http://www.epa.gov/enviro/html/codes/ca.html). 

How does this differ from the USGS's `place` field? Take a look at the record for this [Sept. 20, 2015 earthquake with an `id` of `nn00511445`](http://earthquake.usgs.gov/earthquakes/eventpage/nn00511445#general_summary). 

Its `place` value is: `69km ESE of Lakeview, Oregon`

On a locator map, [it looks like this](http://earthquake.usgs.gov/earthquakes/eventpage/nn00511445#general_map):

![image](files/images/tutorials/spreadsheets/earthquakes/usgs-fips-locator-lakeview.jpg)

However, its `STUSPS` value is `NV`, i.e. the state of __Nevada__, and its `FIPS` is `32031`, i.e. [Washoe County, Nevada](http://quickfacts.census.gov/qfd/states/32/32031.html).


## Why doesn't the USGS provide country or state level data?

Obviously, the USGS could categorize earthquakes by political boundaries, but it chooses to go with `place` labels. In our previous example, why does the USGS choose to use `69km ESE of Lakeview, Oregon`? Maybe because [Lakeview, Oregon](https://en.wikipedia.org/wiki/Lakeview,_Oregon) is the most significant municipality near the earthquake, and thus, describing the earthquake relative to Lakeview is more useful than, `"Somewhere in Washoe County"`.

But in general, think about the _nature_ of earthquakes. They don't abide by our human-made geopolitical boundaries. If California is hit by numerous earthquakes, it's not because of something related to California, the _political entity_, but the fact that California has a [lot of active fault lines](http://earthquake.usgs.gov/regional/nca/ucerf/). So geologists don't care so much about where an earthquake occurs relative to state lines. They care about earthquakes relative to _fault lines_.

### So why care about earthquakes at U.S. state-level?

OK, so what's the purpose of including the __STUSPS__ and __FIPS__ fields? If nothing else, it's a convenient way of categorizing earthquakes; "California had 25 earthquakes in the last month" is more understandable to the average person than "There were 25 earthquakes within the Hayward-Rodgers Creek Fault region in the last month".

But even if earthquakes are generally the result of geological characteristics, there are reasons to quantify earthquakes in terms of human-made __geopolitical__ boundaries. For example, if a massive earthquake were to strike Kansas City, near the split between the Missouri and Kansas state lines, the damage done on a _human_-scale might be more greatly affected by _state boundaries_ rather than physical distance to the earthquake. 

How? Think about how building codes differ between states, cities, and counties.

But what if state-regulated human activity _caused_ earthquakes? Then using the __STUSPS__ field would be _very_ helpful, at least to quantify the correlation.

In the next section, I go over some examples of map visualization, which rely completely on the __latitude__ and __longitude__ fields of the earthquake data. However, parts [2](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2) and [3](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-3) of this tutorial rely completely on the __STUSPS__ and __FIPS__ fields, and by doing so, reveal a more interesting story about a recent trend in U.S.-based earthquake activity.


<a id="mark-why-make-a-map"></a>

# Why a map?

When our data includes geospatial coordinates, i.e. __latitude__ and __longitude__, a map seems like the obvious choice. With mapping software -- in this case, CartoDB -- we don't even have to supply any data and we already have a visual more lovely and sophisticated-looking than just about anything we could create from a typical spreadsheet:

![image](/files/images/tutorials/spreadsheets/earthquakes/cartodb-empty-map.jpg)




## The problems of overplotting

But the primary strength of its map is also its primary _limitation_. Think of a map as a scatterplot with __longitude__ on the x-axis and __latitude__ on the y-axis. A lot of the ink of this "chart" is devoted to showing us Earth's land masses and bodies of water, even before we add any of our data.

Here's what the earthquake data looks like if we don't try to plot it by __time__:


Because there are so many earthquakes, this turns out to be a gigantic clutterfest:


![image](/files/images/tutorials/spreadsheets/earthquakes/cartodb-usgs-all.jpg)



## The third dimension

The first two dimensions of our graph -- the x- and y-axes -- are taken up by longitude and latitude, respectively. To visually represent a _third_ attribute, i.e. _dimension_, of the earthquake data, we can vary either the __color__ or the __size__ of each dot.

- __Note 1:__ Obviously, we could vary _both_ the __size__ and the __color__ of each dot. I don't know how to do that easily with CartoDB, but even if we could, it's not helpful for our current dataset (as we'll soon see). And in most real-world datasets, it can result in a bit of visual overload.
- __Note 2:__ Obviously, when we normally think of __three dimensions__, we think of things sticking _out of the "page"_, i.e. having __depth__. It is tricky to use depth to illustrate data on a flat surface, to say the least. 

We'll deal with those pitfalls of visualization in a later lesson. For now, let's just see what happens when we can use size _or_ color to depict either the __year__ or the __magnitude__ of each earthquake.



### Depicting magnitude with size

Let's use the to show the __mag__ value of each earthquake and visually represent the __z-axis__ by __size__. In other words, __the bigger the magnitude, the bigger the dot__:

<iframe width="100%" height="520" frameborder="0" src="https://dundee.cartodb.com/viz/e20ccde0-62f0-11e5-89ff-0e853d047bba/embed_map" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

It's not a bad strategy but in this specific dataset, it's not helpful because, besides the problem of having 5,500+ dots, it turns out that the vast majority of these earthquakes are between magnitudes of 3 to 4. A map is profoundly unhelpful for showing that kind of breakdown.

<a id="mark-earthquakes-year-color"></a>

### Depicting year of earthquake with color

Let's use each dot's color to indicate what _year_ the given earthquake happened. Quick note: the USGS data doesn't have a year column, but I did some work in CartoDB's SQL editor to derive year from the __time__ column. The exact steps don't matter as we'll learn how (and why) to do it in a spreadsheet.

<iframe width="100%" height="520" frameborder="0" src="https://dundee.cartodb.com/viz/87f3c8ce-62f3-11e5-8231-0e9d821ea90d/embed_map" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

Again, not a bad tactic, but we still have the problem of more than 5,500+ dots to show.

<a id="mark-bins-and-clusters"></a>

## Bins and clusters

The sheer number of data points is our main obstacle to understanding the data. One solution is to simply _remove_ the number of data points by _grouping_ them together with other like data points. This concept is often referred to as __clustering__.

CartoDB actually has a map type named [Cluster](http://docs.cartodb.com/cartodb-editor.html#cluster), in which nearby points are grouped together into a _bigger_ point:

<iframe width="100%" height="520" frameborder="0" src="https://dundee.cartodb.com/viz/b05720ca-62f0-11e5-bbad-0ec6f7c8b2b9/embed_map" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

By clustering -- that is, _aggregating_ points based on their latitude and longitude into a single "glob" -- we sacrifice granularity to gain a clearer overview of the data. This is a technique applies to more than map visualizations, though. In the Parts [2](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2) and [3](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2) of this lesson, we will create bar graphs by "clustering" the earthquake records, but _not_ according to their latitudes and longitudes.


### Rectangular binning

The term __binning__ is sometimes used to refer to the aggregating/clustering of points. In the screenshot below, the CartoDB earthquake data is grouped into square-shaped __bins__. The more points that fall into each square bin, the darker the color of that bin:

![image](/files/images/tutorials/spreadsheets/earthquakes/cartodb-usgs-rect-bin.jpg)

Choosing the size of the bin can drastically change the visualization. Here, the bins are cartoonishly large, painting a picture so broad that we can't even see California as a earthquake-dense state:

![image](files/images/tutorials/spreadsheets/earthquakes/cartodb-big-blocks.jpg)


### Hexbinning

This is basically the same concept as rectangular binning. But besides having a less "boring" look, hexagons have the advantage of being more circular-like, i.e. points on its edges and corners are more equidistant to the center than are the edges and corners of squares:

![image](/files/images/tutorials/spreadsheets/earthquakes/cartodb-usgs-hex-bin.jpg)



Whether you prefer hexagons, squares, or bubbles, again, our main goal is to reduce the visual clutter caused by 5,500+ records. Here's a side-by-side comparison of the original one-dot-for-every-earthquake scatterplot versus the same data, but hexbinned:

![image](/files/images/tutorials/spreadsheets/earthquakes/cartodb-quakes-all-hexes-compare.png)


## Visualizing time with animation

Visualization software like [CartoDB's torque map](http://docs.cartodb.com/tutorials/introduction_torque.html) allow for another kind of axis of visualization: __time__. That is, the chart _changes over time_ -- i.e. the time that is physically passes for the viewer.

So basically, animation. Here's the intro chart again:

<iframe width="100%" height="400" frameborder="0" src="https://dundee.cartodb.com/viz/888634d0-60ae-11e5-93c9-0e018d66dc29/embed_map" allowfullscreen webkitallowfullscreen mozallowfullscreen oallowfullscreen msallowfullscreen></iframe>

So beautiful. And virtually no effort on my part. 


# Why not an animated map?

First of all, this is __not__ a substantiated critique of CartoDB or other mapping software. I have literally put the least amount of effort possible into using their software.  A lengthier discussion on the limitations of maps in general will be saved for another lesson. But Matthew Ericson, a graphics director at the New York Times, said it better than I can with: [When Maps Shouldn’t Be Maps](http://www.ericson.net/content/2011/10/when-maps-shouldnt-be-maps/)

But let's _pretend_ that it is difficult to make a more useful visualization after more sophisticated usage of mapping software -- what can we do better _without_ a map?


## Missing the state-by-state story

So why does an animated map fail in our situation? 

The better question to ask is: __what story is told by this time-lapse map?__

Or, to state it in a viral-news way: 

## THESE TWO CHARTS PROVE WHY ANIMATED MAPS DON'T ALWAYS WORK


<div class="row">
  <div class="col-sm-6">
  <h6>January 2011</h6>
    <img src="/files/images/tutorials/spreadsheets/earthquakes/cartodb-usgs-2011-01.jpg" alt="January 2011 earthquake map">
  </div>
  <div class="col-sm-6">
  <h6>January 2015</h6>
  <img src="/files/images/tutorials/spreadsheets/earthquakes/cartodb-usgs-2015-01.jpg" alt="January 2015 earthquake map">
  </div>
</div>

## The story of Oklahoma

The big story of the 2011 to 2015 M3.0+ USGS earthquake data is that the _state of Oklahoma_, once relatively dormant, is now _just recently_ a hotbed of seismic activity. If the side-by-side screenshots above weren't enough, here's a side-by-side comparison of torque maps for 2011 versus 2014 (roughly):

![cartodb-side-by-side-torques](/files/images/tutorials/spreadsheets/earthquakes/cartodb-side-by-side-torques.gif)

The [New Yorker](http://www.newyorker.com/magazine/2015/04/13/weather-underground) and [NPR](https://stateimpact.npr.org/oklahoma/tag/earthquakes/) have extensively covered Oklahoma's recent earthquake binge and I highly recommend reading their coverage.

But for this exercise, let's pretend we have yet to discover Oklahoma as an outlier. With maps, we can most definitely notice the trend -- but only because it is so _dramatic_. And we can't quite quantify with a map alone.

In the [next part of this lesson](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2), we'll move away from maps and to the humble spreadsheet and bar chart and explore the earthquake data. It will take a little more  work initially, but the concepts will be applicable for all kinds of data, not just geospatial data. And we'll get a clearer picture of Oklahoma's earthquakes.


Continue [on to part 2 of this tutorial](/tutorials/spreadsheets/maps-earthquakes-spreadsheets-part-2).

