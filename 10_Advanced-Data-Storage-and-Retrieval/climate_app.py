import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify

import numpy as np

import datetime as dt

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Flask Routes
#################################################
@app.route("/")
def home():
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f" <br/>"
        f"/api/v1.0/YEAR-MONTH-DAY(of start date)<br/>"
        f"EXAMPLE: /api/v1.0/2017-01-01<br/>"
        f" <br/>"
        f"/api/v1.0/YEAR-MONTH-DAY(start date)/YEAR-MONTH-DAY(end date)<br/>"
        f"EXAMPLE: /api/v1.0/2017-01-01/2018-04-17"
    )

@app.route("/api/v1.0/precipitation")
def precipitation():
    # Query all dates and prcp readings
    session = Session(engine)
    results = session.query(Measurement.date, Measurement.prcp).all()

    # Create dictionary with date as key and prcp as the value
    all_precipitation = []
    for date, prcp in results:
        precipitation_dict = {}
        precipitation_dict[date] = prcp
        all_precipitation.append(precipitation_dict)
    
    return jsonify(all_precipitation)

@app.route("/api/v1.0/stations")
def stations():
    # Query stations
    session = Session(engine)
    results = session.query(Station.station).all()

    # Convert list of tuples into normal list
    all_stations = list(np.ravel(results))

    return  jsonify(all_stations)

@app.route("/api/v1.0/tobs")
def tobs():
    session = Session(engine)

    # Return last date within Measurement column
    last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()

    # Convert last date to datetime object
    last_date = dt.datetime.strptime(last_date[0], "%Y-%m-%d")

    # Subtract 1 year off of last_date
    last_year_date = last_date - dt.timedelta(days=366)

    # Query tobs within last year
    results = session.query(Measurement.date, Measurement.tobs).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) > last_year_date).\
    order_by(Measurement.date).all()

    # Create dictonary
    last_year_tobs = []
    for date, tobs in results:
        tobs_dict = {}
        tobs_dict[date] = tobs
        last_year_tobs.append(tobs_dict)

    return jsonify(last_year_tobs)

@app.route("/api/v1.0/<start>")
def start(start):
    # Convert entered date into date time object
    search_start_date = dt.datetime.strptime(start, "%Y-%m-%d")
    search_start_date = search_start_date - dt.timedelta(days=1)
    
    # Query date, TMIN, TAVG and TMAX for all dates after entered start date
    session = Session(engine)
    results = session.query(Measurement.date, func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
    group_by(Measurement.date).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) >= search_start_date).\
    order_by(func.strftime("%Y-%m-%d", Measurement.date)).all()
    
    # Create dictonary
    start_data = []
    for date, min_tobs, avg_tobs, max_tobs in results:
        start_tobs_dict = {}
        start_tobs_dict["Date"] = date
        start_tobs_dict["Min Temp"] = min_tobs
        start_tobs_dict["Avg Temp"] = avg_tobs
        start_tobs_dict["Max Temp"] = max_tobs
        start_data.append(start_tobs_dict)
    
    return jsonify(start_data)

@app.route("/api/v1.0/<start>/<end>")
def start_end(start, end):
    # Convert entered dates into date time objects
    search_start_date = dt.datetime.strptime(start, "%Y-%m-%d")
    search_start_date = search_start_date - dt.timedelta(days=1)
    search_end_date = dt.datetime.strptime(end, "%Y-%m-%d")

    # Query date, TMIN, TAVG and TMAX for all dates after entered start date and before entered end date
    session = Session(engine)
    results = session.query(Measurement.date, func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
    group_by(Measurement.date).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) >= search_start_date).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) <= search_end_date).\
    order_by(func.strftime("%Y-%m-%d", Measurement.date)).all()
    
    # Create dictonary
    start_end_data = []
    for date, min_tobs, avg_tobs, max_tobs in results:
        start_end_tobs_dict = {}
        start_end_tobs_dict["Date"] = date
        start_end_tobs_dict["Min Temp"] = min_tobs
        start_end_tobs_dict["Avg Temp"] = avg_tobs
        start_end_tobs_dict["Max Temp"] = max_tobs
        start_end_data.append(start_end_tobs_dict)
    
    return jsonify(start_end_data)

if __name__ == "__main__":
    app.run(debug=True)
