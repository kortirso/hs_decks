import React from 'react';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TasksBox extends React.Component {

    constructor() {
        super();
        this.state = {
            standardDecks: [],
            wildDecks: [],
            news: []
        }
    }

    componentWillMount() {
        this._fetchIndexPageData();
        strings.setLanguage(this.props.locale);
    }

    _fetchIndexPageData() {
        $.ajax({
            method: 'GET',
            url: 'pages/index.json',
            success: (data) => {
                this.setState({standardDecks: data.standard_decks, wildDecks: data.wild_decks, news: data.news});
            }
        });
    }

    _prepareDecksList(type) {
        let decksList;
        let header;
        if (type == 'standard') {
            decksList = this._prepareDeck(this.state.standardDecks);
            header = 'Лучшие стандартные колоды';
        } else {
            decksList = this._prepareDeck(this.state.wildDecks);
            header = 'Лучшие вольные колоды';
        }
        return (
            <div className='block'>
                <h2>{header}</h2>
                {decksList}
            </div>
        )
    }

    _prepareDeck(decks) {
        return decks.map((deck) => {
            return (
                <div className='sub_block' key={deck.id}>
                    <div className='image_block'>
                        <img src={`assets/heroes/${deck.player_name}_Big.png`} />
                    </div>
                    <div className='text_block'>
                        <div className='header'>{deck.name}</div>
                        <div className='power'>Сила колоды - {deck.power}</div>
                        <div className='caption'><a href={`decks/${deck.slug}`}>Посмотреть колоду</a></div>
                    </div>
                </div>
            );
        });
    }

    _prepareNewsList() {
        return (
            <div className='block'>
                <h2>Новости</h2>
                {this._prepareNews()}
            </div>
        )
    }

    _prepareNews() {
        return this.state.news.map((article) => {
            return (
                <div className='article_block' key={article.id}>
                    <div className='header'>{article.label}</div>
                    <div className='caption'>{article.caption}</div>
                    <div className='date'>{article.date}</div>
                </div>
            );
        });
    }

    render() {
        return (
            <section className='information'>
                {this._prepareDecksList('standard')}
                {this._prepareDecksList('wild')}
                {this._prepareNewsList()}
            </section>
        );
    }
}

export default TasksBox;