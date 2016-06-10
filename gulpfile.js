const gulp = require('gulp');
const browserify = require('browserify');
const uglify = require('gulp-uglify');
const source = require('vinyl-source-stream');
const streamify = require('gulp-streamify');
const rename = require('gulp-rename');
const babelify = require('babelify');

gulp.task('default', () => {
	browserify('examples/app')
		.transform('babelify', {presets: ['es2015']})
	.bundle()
	.pipe(source('bundle.js'))
	.pipe(streamify(uglify()))
	.pipe(rename('stm32.js'))
	.pipe(gulp.dest('./'));
});