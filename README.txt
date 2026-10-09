KRISHAK - how to run (website + AI engine)

EASIEST (Windows)
1. Install Node.js (LTS) from nodejs.org, if you do not have it.
2. Extract this zip, then double-click  start-krishak.bat
3. First time only: paste your Anthropic API key when asked (saved in your user folder as krishak-key.txt).
4. Your browser opens http://localhost:8787 - the status strip should say "AI engine: connected".
Keep the black window open while you use the site. Close it to stop.
(Use http://localhost:8787, not Live Server, for the AI to work.)

MANUAL (any system)
1. In the "server" folder, copy ".env.example" to ".env" and paste your key after ANTHROPIC_API_KEY=
2. Open a terminal in "server" and run:  npm start
3. Open http://localhost:8787

The key lives ONLY in server/.env. Never put it in index.html.
Each question uses: your farm profile + crop notes (server/knowledge.json) + live weather (Open-Meteo, no key) -> AI.
The crop notes are starter notes, not an official advisory.

---------------------------------------------------------------
ENGLISH + HINDI (हिन्दी) - HOW THE LANGUAGE SWITCHER WORKS
---------------------------------------------------------------
* Use the "English | हिन्दी" switch in the header. The whole page changes instantly (no reload).
  English is the default for first-time visitors; your choice is remembered in the browser (localStorage key krishak.lang.v1).
* All screen text lives in ONE place: the I18N dictionaries at the top of the script in index.html
  (I18N.en and I18N.hi, used through t("key")). To change a word or add a language, edit those dictionaries.
  When adding a new label, add the same key to BOTH languages.
* Only display text is translated. Saved profile values (e.g. stage "Vegetative", soil "Loamy"), API field names,
  weather numbers and dates are never changed by the language.
* The selected language is sent to the AI engine with every question (field "lang": "en" or "hi").
  In Hindi mode the AI writes in simple Devanagari Hindi, using your real farm profile, crop notes and live weather
  (nothing is pre-written). Hindi questions and Hindi crop names (e.g. गेहूँ) also find the right crop notes.
* If you switch language after an answer is shown, the labels change at once; the AI's own sentences stay in the
  language they were written in, and a button lets you get the same answer again in the new language.
* Errors from the engine carry a code (e.g. no_key) and the page shows its own English/Hindi message.
  Raw detail text from Google/Anthropic may be in English.
* Mandi prices are now included (see the MANDI PRICES section below). MSP is still not included.


VOICE FEATURE (VISIBLE ON THE AI ASSISTANT CARD)
1. Start the server and open http://localhost:8787 in Google Chrome or Microsoft Edge.
2. Scroll to “How can I help with your farm?” / AI Assistant. The green bordered “ASK YOUR FARM PROBLEM BY VOICE” panel is directly above the text question box.
3. Select English, Hindi, Punjabi, Tamil, or Telugu, then click “Tap to Speak”.
4. Allow microphone permission in the browser. Speak your farm problem; KRISHAK transcribes it and automatically sends it to the existing Gemini-backed API.
5. Voice recognition is browser-dependent; use current Chrome/Edge. Speech playback depends on the voices installed on the computer.


CROP PHOTO CHECK - "SHOULD I USE FERTILIZER OR PESTICIDE?" (new)
1. On the AI Assistant card, find the blue "CHECK YOUR CROP WITH A PHOTO" panel.
2. On a phone, "Take photo" opens the rear camera. On a computer it opens a file picker. "Choose photo" picks an existing picture (JPEG, PNG, WebP).
3. Take a clear, close picture of the leaves or the affected part, in good light and in focus.
4. Type or speak your question, or just tap "Ask KRISHAK" - with a photo and no question, KRISHAK asks
   "Should I use fertilizer or pesticide on this crop?" for you. The photo stays attached for follow-up questions until you press "Remove photo".
5. The answer has a "Crop photo check" block: what the AI can see in the photo, and a separate verdict for Fertilizer and for Pesticide
   (Likely needed / Not needed now / Wait - check first / Cannot tell from photo), each with a reason. It also uses your farm profile, crop notes and live weather
   (for example it will say wait if heavy rain is coming, because rain washes fertilizer away and spoils spraying).
How it works / limits:
* The photo is shrunk in the browser (max 1280 px) and sent through your local server to the same AI service (Gemini or Anthropic) as your question.
  The key stays in server/.env. KRISHAK does not save the photo; it only lives in the open page.
* The server checks that the file really is a JPEG/PNG/WebP and not too large.
* The AI is told not to give brand names or chemical doses, to say when the photo is unclear, and to avoid claiming a certain diagnosis from a picture.
  A photo cannot prove a disease or nutrient shortage: confirm with your local KVK or agriculture officer before buying or spraying chemicals.
* Works in English and Hindi (the answer follows the language you picked). Needs a vision-capable model: the default Gemini and Claude models are.
* Camera access on a computer/phone needs http://localhost (or https). If you open the site from another device on your network, use the "Choose photo" button instead.
Also fixed in this version: when the page was in Hindi but the voice language box still said English, answers came back in English and the
"get this answer in Hindi" button looped. The answer-language box now follows the language switch.


MANDI PRICES - REAL DAILY WHOLESALE RATES (new)
What it shows: a "Mandi Prices" card (menu: Mandi Prices) with real prices for your crop in your state:
average / highest / lowest "modal" price (the most common price of the day), and a table of mandis with Min, Max, Modal
in rupees per quintal (100 kg), plus the approximate price per kg. Mandis in your own district are marked "Near you" and listed first.
Where the data comes from: Agmarknet (Directorate of Marketing & Inspection, Govt. of India), the official source that most
mandi-price apps and websites use. It is read through the free data.gov.in API
(dataset "Current Daily Price of Various Commodities from Various Markets (Mandi)").
One-time setup (free, about 2 minutes):
1. Sign up at https://data.gov.in and copy your API key from My Account.
2. Windows: start-krishak.bat asks "Mandi key:" - paste it (or press Enter to skip). It is saved as krishak-mandi-key.txt in your user folder.
   Manual: put  DATA_GOV_API_KEY=your-key  in server/.env  (see .env.example) and run npm start.
3. The status strip should say "Mandi prices: ready".
How it works / limits:
* The key stays on the server (never in index.html). Results are cached for 30 minutes to be kind to the free service.
* The state is read from the last part of your profile location (e.g. "Kanpur, Uttar Pradesh"); if it is not recognised, pick it in the State box.
  The crop box starts with your profile crop; type another crop and press Enter. English, Hindi and Hinglish names work for common crops
  (wheat/gehun/गेहूँ, paddy/dhan, mustard/sarson, onion, potato, tomato, gram/chana, ...). Agmarknet needs exact commodity names, so a crop
  that is not in the built-in list is sent exactly as typed and may return nothing.
* Only the newest report per mandi/variety is shown, and reports older than 7 days before the newest date are dropped.
* These are wholesale mandi prices. They can be a day or more old, some mandis do not report every day, and the price a farmer actually
  gets depends on quality, variety and fees. The page says so. The prices are NOT given to the AI assistant.
* Prices in Hindi mode: labels are translated; mandi names, varieties and numbers come from Agmarknet as written.
