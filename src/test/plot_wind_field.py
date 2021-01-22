# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.9.1
#   kernelspec:
#     display_name: dbcontrol
#     language: python
#     name: dbcontrol
# ---

from mpl_toolkits.basemap import Basemap  # import Basemap matplotlib toolkit
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as pltcolors
import pygrib # import pygrib interface to grib_api

# +
data_dir = '../../data/'
data_grb_name = 'gfs_4_20210118_0000_000.grb2'
grbs = pygrib.open(data_dir + data_grb_name)

for grb in grbs:
    print(grb)
# -

print(grb.keys())

# +
grbs.rewind()
grb_wind_v = [grb for grb in grbs if grb.parameterName == 'v-component of wind']

grbs.rewind()
grb_wind_u = [grb for grb in grbs if grb.parameterName == 'u-component of wind']

grb_wind_v[1]

# +
grbs.rewind() # rewind the iterator
t2mens = []
# for grb in grbs:
#    if grb.parameterName == 'Temperature' and grb.level == 2: 
#        t2mens.append(grb.values)
    
t2mens.append(grb_wind_v[1].values)

t2mens = np.array(t2mens)
print(t2mens.shape, t2mens.min(), t2mens.max())
lats, lons = grb.latlons()
print('min/max lat and lon',lats.min(), lats.max(), lons.min(), lons.max())
# -

np.square(grb_wind_u[0].values)+np.square(grb_wind_v[0].values)

# +
fig = plt.figure(figsize=(32,70))
m = Basemap(projection='lcc',lon_0=0,lat_0=52,width=2.e6,height=2.e6)
x,y = m(lons,lats)

for i in range(9): #ange(len(grb_wind_u)):
    ax = plt.subplot(3,3,i+1)
    m.drawcoastlines()
    i_data = 3*i
    cs = m.contourf(x,y,np.square(grb_wind_u[i_data].values)+np.square(grb_wind_v[i_data].values),cmap=plt.cm.jet,extend='both')
    m.quiver(x,y, grb_wind_u[i_data].values, grb_wind_v[i_data].values, width=0.001, scale=1000) # , norm=pltcolors.Normalize()
    t = plt.title('ens member %s' % i)
# -

x.shape
y.shape


