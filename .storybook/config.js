/**
 * External dependencies
 */
import 'prismjs';
import { configure, setAddon } from '@storybook/react';
import infoAddon from '@storybook/addon-info';
import { setOptions } from '@storybook/addon-options';

/**
 * Internal dependencies
 */
import * as element from 'element';
import './style.scss';

function loadStories() {
	window.wp = { ...window.wp, element };
	require( '../components/story' );
	require( '../components/button/story' );
}

setOptions( {
	name: 'Gutenberg',
	url: 'https://github.com/WordPress/gutenberg',
	goFullScreen: false,
	showLeftPanel: true,
	showDownPanel: true,
	showSearchBox: false,
	downPanelInRight: true,
	sortStoriesByKind: false,
} );
setAddon( infoAddon );

configure( loadStories, module );
