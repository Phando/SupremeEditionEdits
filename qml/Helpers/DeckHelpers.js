// primary decks default to track, secondary decks default to remix
function defaultDeckType(deckId) {
    return (deckId > 2) ? DeckType.Remix : DeckType.Track
}

function hasTrackProperties(deckType) {
    return deckType == DeckType.Track || deckType == DeckType.Stem
}

function linkedDeckId(deckId) {
    switch (deckId) {
        // Deck A and C are linked
        case 1: return 3;
        case 3: return 1;
        // Deck B and D are linked
        case 2: return 4;
        case 4: return 2;
    }
}