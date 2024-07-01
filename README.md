## Description
The preinstalled ```OSC_preprocessing``` script in siril only considers images from one session. If one captured a target along serveral night it becomes very unhandy to stack all the light frames. 
This script calibrates the light frame from each session with their individual dark, bias and flat frames, and stacks them afterward.

## Usage
The script expects a file structure like the following:
<ul>
  <li>&lt;target-directory&gt;
    <ul>
      <li>&lt;session-name-1&gt;
        <ul>
          <li>biases</li>
          <li>darks</li>
          <li>flats</li>
          <li>lights</li>
        </ul>
      </li>
      <li>&lt;session-name-2&gt;
        <ul>
          <li>biases</li>
          <li>darks</li>
          <li>flats</li>
          <li>lights</li>
        </ul>
      </li>
      <li>...</li>
    </ul>
  </li>
</ul>


Then run the script with:
```
bash OSC_Multi_Preprocessing.sh <target-directory>
```
