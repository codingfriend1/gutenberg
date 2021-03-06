<?php
/**
 * Plugin Name: Gutenberg
 * Plugin URI: https://github.com/WordPress/gutenberg
 * Description: Prototyping since 1440. This is the development plugin for the new block editor in core. <strong>Meant for development, do not run on real sites.</strong>
 * Version: 0.1.0
 * Author: Gutenberg Team
 *
 * @package gutenberg
 */

define( 'GUTENBERG__PLUGIN_DIR', plugin_dir_path( __FILE__ ) );

require_once dirname( __FILE__ ) . '/lib/blocks.php';
require_once dirname( __FILE__ ) . '/lib/client-assets.php';
require_once dirname( __FILE__ ) . '/lib/i18n.php';
require_once dirname( __FILE__ ) . '/lib/register.php';
