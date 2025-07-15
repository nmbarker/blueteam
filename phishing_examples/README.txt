The phishing exmaples contained within this repo do not directly download anything to your workstation, however, should still tread lightly.

# securedoc_135020215.htm
Analysis: File sent to user over email. Opens a fake Proofpoint page that looks like US Bank. All links on the page redirect to 'prosperprotagonist.pt' which as of 15JULY2025 no longer points to a valid redirect target. After pulling the source from securedoc the only information I was able to gather was that what I was decrypting was Proofpoint's own encryption software. Threat actor (owner of prosperprotagonist.pt) only changed the site redirects and did not actually create what look like an encrypted payload within the .htm file. 

tl;dr
Threat Actor used a legitimate home page and just changed the redirects on it to point to another URL. That URL would then resolve to a Microsoft-like login page where it would harvest credentials. As of 15JULY2025 the webpage no longer works. 


