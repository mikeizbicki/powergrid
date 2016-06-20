#

All the functions for the Kalman filter are in the `ekfukf` folder.
It must be added to the path.

```
addpath "./ekfukf"
```

The models are stored in the `models` folder.
To select a model, source its contents.

```
source "models/random.m"
```

Then sample from the model by

```
source "sample.m"
```

Then run the filter on the sampled data by

```
source "filter.m"
```
